#include "qmlapi.h"

#include <QDebug>

#include "networkaccessmanagerfactory.h"
#include "htmlparser.h"

QmlApi::QmlApi(QObject *parent) : QObject(parent)
{
}

void QmlApi::clearCookies()
{
    NetworkCookieJar::Instance()->clearCookies();
}

QVariantList QmlApi::parseHtml(const QString &html)
{
    return HtmlParser::Instance()->parseHtml(html);
}
