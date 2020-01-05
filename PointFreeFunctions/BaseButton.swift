//
//  BaseButton.swift
//  PointFreeFunctions
//
//  Created by 양원석 on 2020/01/06.
//  Copyright © 2020 양원석. All rights reserved.
//

import UIKit

// subclassing

class BaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FilledButton: RoundedButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RoundedButton: BaseButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//compose

extension UIButton {
    
    static var base: UIButton {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }
    
    static var filled: UIButton {
        let button = Self.base
        button.backgroundColor = .black
        button.tintColor = .white
        return button
    }
    
    static var rounded: UIButton {
        let button = Self.filled
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        return button
    }
    
}

//func baseButtonStyle(_ button: UIButton) {
//    button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
//    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
//}

let baseButtonStyle: (UIButton) -> Void = {
    $0.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
}

//func roundedButtonStyle(_ button: UIButton) {
//    button.clipsToBounds = true
//    button.layer.cornerRadius = 6
//}
let roundedButtonStyle = baseButtonStyle
    <> roundedStyle

//func filledButtonStyle(_ button: UIButton) {
//    button.backgroundColor = .black
//    button.tintColor = .white
//}
let filledButtonStyle = roundedButtonStyle
    <> {
        $0.backgroundColor = .black
        $0.tintColor = .white
}

let roundedStyle: (UIView) -> Void = {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 6
}

let borderButtonStyle = roundedButtonStyle
    <> borderStyle(color: .black, width: 2)
    <> {
        $0.setTitleColor(.black, for: .normal)
}

let textButtonStyle = baseButtonStyle
    <> {
        $0.setTitleColor(.black, for: .normal)
}

let imageButtonStyle: (UIImage?) -> (UIButton) -> Void = { image in
    { button in
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        button.setImage(image, for: .normal)
    }
}

let githubButtonStyle = filledButtonStyle
    <> imageButtonStyle(UIImage(named: "github"))

/// textFields

let baseTextFieldStyle: (UITextField) -> Void = roundedStyle
    <> borderStyle(color: .init(white: 0.75, alpha: 1), width: 1)
    <> {
        $0.borderStyle = .roundedRect
        $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
        $0.layer.borderColor = UIColor(white: 0.75, alpha: 1).cgColor
        $0.layer.borderWidth = 1
}

let emailTextFieldStyle = baseTextFieldStyle
    <> {
        $0.keyboardType = .emailAddress
        $0.placeholder = "blob@abc.com"
}

let passwordTextFieldStyle = baseTextFieldStyle
    <> {
        $0.isSecureTextEntry = true
        $0.placeholder = "••••••••••••••••"
}

//let borderStyle: (UIView) -> Void = {
//    $0.layer.borderColor = ???
//    $0.layer.borderWidth = ???
//}

func borderStyle(color: UIColor, width: CGFloat) -> (_ view: UIView) -> Void {
    { view in
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width
    }
}

/// labels

func fontStyle(ofSize size: CGFloat, weight: UIFont.Weight) -> (UILabel) -> Void {
    { label in
        label.font = .systemFont(ofSize: size, weight: weight)
    }
}

func textColorStyle(_ color: UIColor) -> (UILabel) -> Void {
    { label in
        label.textColor = color
    }
}

func alignStyle(_ alignment: NSTextAlignment) -> (UILabel) -> Void {
    { label in
        label.textAlignment = alignment
    }
}

let centerStyle = alignStyle(.center)

/// hyper-local

let orLabelStyle: (UILabel) -> Void = centerStyle
    <> fontStyle(ofSize: 14, weight: .medium)
    <> textColorStyle(.init(white: 0.625, alpha: 1))

let finePrintStyle: (UILabel) -> Void = centerStyle
    <> fontStyle(ofSize: 14, weight: .medium)
    <> textColorStyle(.init(white: 0.5, alpha: 1))
    <> {
        $0.font = .systemFont(ofSize: 11, weight: .light)
        $0.numberOfLines = 0
}

let gradientStyle: (GradientView) -> Void = autolayoutStyle
    <> {
        $0.fromColor = UIColor(red: 0.5, green: 0.85, blue: 1, alpha: 0.85)
        $0.toColor = .white
}

/// stackViews
let rootStackViewStyle: (UIStackView) -> Void = autolayoutStyle
    <> {
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 32, left: 16, bottom: 32, right: 16)
        $0.spacing = 16
}

/// autolayout related...

func autolayoutStyle<V: UIView>(_ view: V) {
    view.translatesAutoresizingMaskIntoConstraints = false
}

func aspectRatioStyle<V: UIView>(size: CGSize) -> (V) -> Void {
    {
        $0.widthAnchor
            .constraint(equalTo: $0.heightAnchor, multiplier: size.width / size.height)
            .isActive = true
    }
}

func implicitAspectRatioStyle<V: UIView>(_ view: V) {
    aspectRatioStyle(size: view.frame.size)(view)
}

func roundedRectStyle<View: UIView>(_ view: View) {
    view.clipsToBounds = true
    view.layer.cornerRadius = 6
}
