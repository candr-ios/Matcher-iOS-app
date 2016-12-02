#!/bin/sh

url=https://static.realm.io/downloads/objc/realm-objc-2.1.0.zip

mkdir ./tmp/ && \
cd ./tmp/ && \
curl -sS $url > realm.zip && \
unzip realm.zip && \
rm realm.zip && \
cp -R realm-objc-2.1.0/ios/dynamic/Realm.framework .. && \
cd .. && \
rm -rf tmp 
