//
//  ViewController.swift
//  Draw_any
//
//  Created by HaiPhan on 6/28/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit

class Canvas : UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
//        context.setStrokeColor(setStrokeColor.cgColor)
//        context.setLineWidth(width_line)
        context.setLineCap(.butt)
//        //poin start
//        let start = CGPoint(x: 0, y: 0)
//        context.move(to: start)
//        //point end
//        let end = CGPoint(x: 50, y: 100)
//        context.addLine(to: end)
        //các điểm k ngắt nhau
//        for (i,p) in array_point.enumerated() {
//            if i == 0 {
//                context.move(to: p)
//            }
//            else {
//                context.addLine(to: p)
//            }
//        }
        
        array_point.forEach { (line) in
            context.setStrokeColor(line.line_color.cgColor)
            context.setLineWidth(line.width)
            for (i,p) in line.line_point.enumerated() {
                if i == 0 {
                    context.move(to: p)
                }
                else {
                    context.addLine(to: p)
                }
            }
            //kết nối các điểm
            context.strokePath()
        }
        
        //kết nối các điểm
//        context.strokePath()
        

        
    }
//    //tạo 1 mảng point
//    var array_point: [CGPoint] = [CGPoint]()
    //tạo 1 mảng gồm phần từ là các mảng CGPoint
    var array_point = [line_object]()
    var width_line : CGFloat = 1
    var setStrokeColor = UIColor.white
    
    func handle_color(color: UIColor){
        self.setStrokeColor = color
    }
    
    func handle_width(width: CGFloat){
       self.width_line = width
    }

    func handle_undo(){
        array_point.popLast()
        setNeedsDisplay()
    }
    
    func handle_clean(){
        array_point.removeAll()
        //viết hamd này để update ui
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        array_point.append(line_object(width: width_line, line_color: setStrokeColor, line_point: []))
//        array_point.append([CGPoint]())
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard  let point = touches.first?.location(in: nil) else {
            return
        }
        //các điểm ngắt nhau
        guard var lastline = array_point.popLast() else {
            return
        }
        lastline.line_point.append(point)
        array_point.append(lastline)

        //các điểm sẽ nôsi tiếp nhau mf k ngắt
//        array_point.append(point)
        
        //add this lines then draw just work
        setNeedsDisplay()
    }
}

class ViewController: UIViewController {
    let undo_button : UIButton = {
        let bt = UIButton()
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        bt.setTitle("Undo", for: .normal)
        bt.addTarget(self, action: #selector(handle_undo), for: .touchUpInside)
        return bt
    }()
    
    @objc func handle_undo(){
        canvas.handle_undo()
    }
    let clean_button : UIButton = {
        let bt = UIButton()
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        bt.setTitle("Clean", for: .normal)
        bt.addTarget(self, action: #selector(handle_clean), for: .touchUpInside)
        return bt
    }()
    
    let red_button : UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(handle_red), for: .touchUpInside)
        bt.backgroundColor = UIColor.red
        bt.layer.borderWidth = 1
        return bt
    }()
    
    @objc func handle_red(){
        canvas.handle_color(color: UIColor.red)
    }
    
    let yellow_button : UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(handle_yellow), for: .touchUpInside)
        bt.backgroundColor = UIColor.yellow
        bt.layer.borderWidth = 1
        return bt
    }()
    
    @objc func handle_yellow(){
        canvas.handle_color(color: UIColor.yellow)
    }
    
    let blue_button : UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(handle_blue), for: .touchUpInside)
        bt.backgroundColor = UIColor.blue
        bt.layer.borderWidth = 1
        return bt
    }()
    @objc func handle_blue(){
        canvas.handle_color(color: UIColor.blue)
    }
    let width_slider : UISlider = {
       let sl = UISlider()
        sl.minimumValue = 1
        sl.maximumValue = 20
        sl.minimumTrackTintColor = UIColor.red
        sl.maximumTrackTintColor = UIColor.white
        sl.addTarget(self, action: #selector(handle_width), for: .valueChanged)
        return sl
    }()
    @objc func handle_width(){
        canvas.handle_width(width: CGFloat(width_slider.value))
    }

    
    @objc func handle_clean(){
        canvas.handle_clean()
    }
    let canvas = Canvas()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(canvas)
        canvas.frame = view.frame
        canvas.backgroundColor = .black
        
        //add tất cả element trên 1 line = 1 stack view
        
        let color_view = UIStackView(arrangedSubviews: [red_button, yellow_button, blue_button])
        color_view.distribution = .fillEqually
        
        let text_view = UIStackView(arrangedSubviews: [undo_button, clean_button, color_view, width_slider])
        text_view.distribution = .fillEqually
        text_view.backgroundColor = UIColor.white
        text_view.spacing = 10
        view.addSubview(text_view)
        
        text_view.translatesAutoresizingMaskIntoConstraints = false
        text_view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        text_view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        text_view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        text_view.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }


}

