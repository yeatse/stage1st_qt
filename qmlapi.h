#ifndef QMLAPI_H
#define QMLAPI_H

#include <QObject>

class QmlApi : public QObject
{
    Q_OBJECT
public:
    explicit QmlApi(QObject *parent = 0);
    Q_INVOKABLE void clearCookies();
};

#endif // QMLAPI_H
