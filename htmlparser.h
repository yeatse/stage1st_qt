#ifndef HTMLPARSER_H
#define HTMLPARSER_H

#include <QVariant>
#include "singletonbase.h"

class HtmlParser
{
    DECLARE_SINGLETON(HtmlParser)
public:
    QVariantList parseHtml(const QString& html);

private:
    HtmlParser();

    bool isS1Emoticon(const QString& src);
    QString s1EmoticonToImageTag(const QString& src);

    QString addAnchorTag(const QString& text, const QString& href);
    QString addItalicTag(const QString& text);
};

#endif // HTMLPARSER_H
