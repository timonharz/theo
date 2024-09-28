//
//  File.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//


import SwiftUI

extension View {
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
    func getSafeArea()->UIEdgeInsets {
            return UIApplication.shared.windows.first?.safeAreaInsets
             ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        }
    @ViewBuilder func unredacted(when condition: Bool) -> some View {
        if condition {
        unredacted()
        } else {
            redacted(reason: .placeholder)
        }
    }
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
