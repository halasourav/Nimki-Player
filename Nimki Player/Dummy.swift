//
//  Dummy.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 18/04/25.
//

import SwiftUI

struct Dummy: View {
    let triangleSize: CGFloat = 50 // Increased triangle size
        let spacing: CGFloat = 25      // Adjusted spacing for larger triangles
        let initialClusterSize: Int = 15 // Number of triangles in the initial cluster

        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Color.white.ignoresSafeArea() // Optional background

                    ForEach(0..<initialClusterSize) { index in
                        let row = CGFloat(index % 5) // Adjust for the desired cluster width
                        let col = CGFloat(index / 5) // Adjust for the desired cluster height

                        // Position the initial cluster in the bottom right
                        let startX = geometry.size.width * 0.75 // Adjust for horizontal placement
                        let startY = geometry.size.height * 0.75 // Adjust for vertical placement

                        // Offset each triangle within the cluster
                        let xOffset = startX + row * spacing - CGFloat(initialClusterSize / 2) * spacing / 2 // Center roughly
                        let yOffset = startY + col * spacing * 0.866 - CGFloat(initialClusterSize / 3) * spacing * 0.866 / 2 // Center roughly

                        Path { path in
                            path.move(to: CGPoint(x: 0, y: triangleSize * 0.866))
                            path.addLine(to: CGPoint(x: triangleSize / 2, y: 0))
                            path.addLine(to: CGPoint(x: triangleSize, y: triangleSize * 0.866))
                            path.addLine(to: CGPoint(x: 0, y: triangleSize * 0.866))
                        }
                        .fill(Color.blue)
                        .opacity(calculateOpacity(x: xOffset / geometry.size.width, y: yOffset / geometry.size.height))
                        .offset(x: xOffset, y: yOffset)
                        .rotationEffect(Angle(degrees: Double.random(in: -30...30))) // Add some slight rotation
                    }
                }
            }
            .ignoresSafeArea()
        }

        func calculateOpacity(x: CGFloat, y: CGFloat) -> Double {
            // x and y are normalized (0 to 1)

            // We want higher opacity in the bottom right (where x and y are larger)
            // and lower opacity towards the top left (where x and y are smaller)

            // You can adjust these factors to control the fading
            let xFactor: CGFloat = 1.0 // How much x position affects opacity
            let yFactor: CGFloat = 1.0 // How much y position affects opacity

            return max(0, (x * xFactor + y * yFactor) / (xFactor + yFactor))
        }
}

#Preview {
    Dummy()
}
