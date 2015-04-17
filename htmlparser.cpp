#include "htmlparser.h"

#include <QTextDocument>
#include <QTextBlock>
#include <QFile>

const int MaxRichTextLength = 100;

class BlockData
{
public:
    enum { PlainText, RichText, Image };

    int format;
    QString content;
    bool italic;

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
    map.insert("italic", italic);
    return map;
}

HtmlParser::HtmlParser()
{
}

QVariantList HtmlParser::parseHtml(const QString &html)
{
    QList<BlockData*> list;

    QTextDocument doc;
    doc.setHtml(fixHtml(html));

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
                else {
                    data->format = BlockData::PlainText;
                    data->content = fragment.text();
                }
            }

            data->italic = format.fontItalic();

            if (blockList.isEmpty() || data->format == BlockData::Image) {
                blockList.append(data);
            }
            else {
                BlockData* lastData = blockList.last();
                if (lastData->format == BlockData::Image || lastData->italic != data->italic) {
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

QString HtmlParser::fixHtml(const QString &html)
{
    return QString(html)
            .replace(QRegExp("<blockquote>([\\s\\S]*)</blockquote>"), "<i>\\1</i>")
            .replace("<imgwidth", "<img width");
}

bool HtmlParser::isS1Emoticon(const QString &src)
{
    return src.startsWith("static/image/smiley");
}

QString HtmlParser::s1EmoticonToImageTag(const QString &src)
{
    QString file = QString(src).replace("static/image/smiley/", ":/emoticon/");
    if (QFile::exists(file))
        return QString("<img src=\"%1\"/>").arg(file);
    else
        return QString("<img src=\"http://bbs.saraba1st.com/2b/%1\"/>").arg(src);
}

QString HtmlParser::addAnchorTag(const QString &text, const QString &href)
{
    return QString("<a href=\"%1\">%2</a>").arg(href, text);
}
