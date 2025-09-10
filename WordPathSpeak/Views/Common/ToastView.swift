//
//  ToastView.swift
//  WordPathSpeak
//
//  Created by Steven Mahathirath on 9/1/25.
//
import SwiftUI

struct ToastView: View {
    let title: String
    let subtitle: String?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "rosette").imageScale(.large)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                if let s = subtitle, !s.isEmpty {
                    Text(s).font(.caption).foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.25)))
        .shadow(radius: 8)
        .padding(.horizontal, 16)
    }
}

