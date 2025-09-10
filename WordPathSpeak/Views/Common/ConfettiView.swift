//
//  ConfettiView.swift
//  WordPathSpeak
//
//  Created by Steven Mahathirath on 9/1/25.
//
import SwiftUI
import UIKit

struct ConfettiView: UIViewRepresentable {
    let duration: TimeInterval
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async { showConfetti(on: view) }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    private func showConfetti(on view: UIView) {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.bounds.midX, y: -10)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: view.bounds.size.width, height: 1)
        
        func makeCell(color: UIColor) -> CAEmitterCell {
            let cell = CAEmitterCell()
            cell.birthRate = 10
            cell.lifetime = 6.0
            cell.velocity = 200
            cell.velocityRange = 50
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 8
            cell.spin = 3.5
            cell.spinRange = 1.0
            cell.scale = 0.6
            cell.scaleRange = 0.3
            cell.contents = UIImage(systemName: "circle.fill")?
                .withTintColor(color, renderingMode: .alwaysOriginal).cgImage
            return cell
        }
        
        emitter.emitterCells = [
            makeCell(color: .systemPink),
            makeCell(color: .systemTeal),
            makeCell(color: .systemYellow),
            makeCell(color: .systemGreen),
            makeCell(color: .systemPurple),
            makeCell(color: .systemOrange)
        ]
        view.layer.addSublayer(emitter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            emitter.birthRate = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                emitter.removeFromSuperlayer()
            }
        }
    }
}

