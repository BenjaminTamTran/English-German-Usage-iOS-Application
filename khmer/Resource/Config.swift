//
//  Config.swift
//  khmer
//
//  Created by Tran Huu Tam on 11/8/14.
//  Copyright (c) 2014 BenjaminSoft. All rights reserved.
//

/*
    Technical notes:
        1. Core data sample
        2. Core data issue: http://stackoverflow.com/questions/8881453/the-model-used-to-open-the-store-is-incompatible-with-the-one-used-to-create-the
*/

import Foundation

let baseURL = "http://en.bab.la/dictionary/english-german"
let otherBaseURL = "http://en.bab.la/dictionary/german-english"
let deviceIdidom = UIDevice.currentDevice().userInterfaceIdiom
let adUnit = "a152e14e8951ef3"
let googleServiceImages = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0"
let keyPreference = "appPreferences"
let queueName = "com.tranhuutam.AppQueue"
let appDelegate: AppDelegate       = UIApplication.sharedApplication().delegate as AppDelegate
let appUserPreference = appDelegate.userPreference!
let keywordListKey = "keywordListKey"
let languageKey = "languageKey"
let otherLang = "G"
let searchTextOtherLang = "Suche"
let utteraceOther = "de-de"
let utteraceEnglish = "en-GB"
let sampleOtherLanguage = "familie"
let databaseSqlite = "german.sqlite"