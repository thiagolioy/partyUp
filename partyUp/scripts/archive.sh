#!/bin/sh
mkdir releases
rm releases/*
xcodebuild -workspace partyUp.xcworkspace -scheme partyUp -archivePath ./partyUp.xcarchive clean build archive
xcodebuild -archivePath ./partyUp.xcarchive -exportArchive -exportFormat IPA -exportPath ./releases/partyUp-`date +%Y%m%d%H%M%S`.ipa -exportProvisioningProfile 'PartyUp_Development_Profile'
