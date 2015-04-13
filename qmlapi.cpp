#include "qmlapi.h"

#include <QDebug>

#include "networkaccessmanagerfactory.h"

QmlApi::QmlApi(QObject *parent) : QObject(parent)
{
}

void QmlApi::clearCookies()
{
    NetworkCookieJar::Instance()->clearCookies();
}
