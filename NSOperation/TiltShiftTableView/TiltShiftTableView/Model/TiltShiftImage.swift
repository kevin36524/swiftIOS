//
//  TiltShiftImage.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/6/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import Foundation

struct TiltShiftImage {
    let imageName: String
    let imageTitle: String
}

extension TiltShiftImage {
    static func loadDefaultData() -> [TiltShiftImage] {
        return [
            TiltShiftImage(imageName: "sample_01_small", imageTitle: "Camels"),
            TiltShiftImage(imageName: "sample_02_small", imageTitle: "Desert Camp"),
            TiltShiftImage(imageName: "sample_03_small", imageTitle: "Sky Train At Night"),
            TiltShiftImage(imageName: "sample_04_small", imageTitle: "Sky Train At Day"),
            TiltShiftImage(imageName: "sample_05_small", imageTitle: "CityScape"),
            TiltShiftImage(imageName: "sample_06_small", imageTitle: "Daytime Sky Train"),
            TiltShiftImage(imageName: "sample_07_small", imageTitle: "Golder Arches"),
            TiltShiftImage(imageName: "sample_08_small", imageTitle: "Aeroplane"),
            TiltShiftImage(imageName: "sample_09_small", imageTitle: "Traffic at Night"),
        ]
    }
}

extension TiltShiftImage: Equatable { }

func ==(lhs: TiltShiftImage, rhs: TiltShiftImage) -> Bool {
    return lhs.imageName == rhs.imageName && lhs.imageTitle == rhs.imageTitle
}
