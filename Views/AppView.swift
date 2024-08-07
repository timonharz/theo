//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import SwiftUI

struct AppView: View {
  @AppStorage("onboardingDone") var onboardingDone: Bool = false


    var body: some View {
      if onboardingDone {
        TheoTabsView().onDeviceShake {
          print("Device got shaken")
        }
      } else {
        OnboardingView()
      }
    }
}

#Preview {
    AppView()
}
