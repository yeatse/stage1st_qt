#include "htmlparser.h"

#include <QTextDocument>
#include <QTextBlock>

const int MaxRichTextLength = 500;

class BlockData
{
public:
    enum { PlainText, RichText, Image };

    int format;
    QString content;

    void append(BlockData* other);
    QVariantMap toMap() const;
};

void BlockData::append(BlockData *other)
{
    bool isPlainText = format == PlainText && other->format == PlainText;
    if (isPlainText) {
        content.append(other->content);
    }
    else {
        format = RichText;
        content.append(other->content);
    }
}

QVariantMap BlockData::toMap() const
{
    QVariantMap map;
    map.insert("format", format);
    map.insert("content", content);
    return map;
}

HtmlParser::HtmlParser()
{
}

QVariantList HtmlParser::parseHtml(const QString &html)
{
    QList<BlockData*> list;

    QTextDocument doc;
    doc.setHtml(QString(html).replace(QRegExp("<blockquote>([\\s\\S]*)</blockquote>"),
                                      "<i>\\1</i>"));

    for (QTextBlock block = doc.firstBlock(); block != doc.end(); block = block.next()) {
        QList<BlockData*> blockList;

        for (QTextBlock::iterator it = block.begin(); !it.atEnd(); ++it) {
            BlockData* data = new BlockData;

            QTextFragment fragment = it.fragment();
            QTextCharFormat format = fragment.charFormat();

            if (format.objectType() == QTextFormat::ImageObject) {
                QString imgSrc = format.toImageFormat().name();
                if (isS1Emoticon(imgSrc)) {
                    data->format = BlockData::RichText;
                    data->content = s1EmoticonToImageTag(imgSrc);
                }
                else {
                    data->format = BlockData::Image;
                    data->content = imgSrc;
                }
            }
            else {
                if (format.isAnchor()) {
                    data->format = BlockData::RichText;
                    data->content = addAnchorTag(fragment.text(), format.anchorHref());
                }
                else if (format.fontItalic()) {
                    data->format = BlockData::RichText;
                    data->content = addItalicTag(fragment.text());
                }
                else {
                    data->format = BlockData::PlainText;
                    data->content = fragment.text();
                }
            }

            if (blockList.isEmpty() || data->format == BlockData::Image) {
                blockList.append(data);
            }
            else {
                BlockData* lastData = blockList.last();
                if (lastData->format == BlockData::Image) {
                    blockList.append(data);
                }
                else if (lastData->format == BlockData::RichText || data->format == BlockData::RichText) {
                    if (lastData->content.length() + data->content.length() > MaxRichTextLength) {
                        blockList.append(data);
                    }
                    else {
                        lastData->append(data);
                        delete data;
                    }
                }
                else {
                    lastData->append(data);
                    delete data;
                }
            }
        }

        list.append(blockList);
    }

    QVariantList result;
    foreach (BlockData* data, list) {
        result.append(data->toMap());
    }
    qDeleteAll(list);

    return result;
}

bool HtmlParser::isS1Emoticon(const QString &src)
{
    return src.startsWith("static/image/smiley");
}

QString HtmlParser::s1EmoticonToImageTag(const QString &src)
{
    return QString("<img src=\"http://bbs.saraba1st.com/2b/%1\"/>").arg(src);
}

QString HtmlParser::addAnchorTag(const QString &text, const QString &href)
{
    return QString("<a href=\"%1\">%2</a>").arg(href, text);
}

QString HtmlParser::addItalicTag(const QString &text)
{
    return QString("<i>%1</i>").arg(text);
}
