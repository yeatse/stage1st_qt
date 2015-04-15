#ifndef QMLAPI_H
#define QMLAPI_H

#include <QObject>
#include <QVariant>

class QmlApi : public QObject
{
    Q_OBJECT
public:
    explicit QmlApi(QObject *parent = 0);
    Q_INVOKABLE void clearCookies();
    Q_INVOKABLE QVariantList parseHtml(const QString& html);
};

#endif // QMLAPI_H
