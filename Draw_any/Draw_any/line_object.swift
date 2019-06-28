//
//  line_object.swift
//  Draw_any
//
//  Created by HaiPhan on 6/28/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit

class line_object {
    var width : CGFloat!
    var line_color: UIColor!
    var line_point: [CGPoint]!
    
    init(width: CGFloat, line_color: UIColor, line_point: [CGPoint] ) {
        self.width = width
        self.line_color = line_color
        self.line_point = line_point
    }
}

