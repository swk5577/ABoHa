//
//  UIBlurView.swift
//  ABoHa2024_12_5
//
//  Created by jmynambu on 12/7/24.
//

import SwiftUI

struct UIBlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
