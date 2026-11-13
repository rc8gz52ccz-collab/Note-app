import SwiftUI

var bodyGradient: LinearGradient {
    LinearGradient(
        stops: [
            .init(color: Color(white: 0.12), location: 0.02),
            .init(color: Color(white: 0.27), location: 0.03),
            .init(color: Color(white: 0.20), location: 0.08),
            .init(color: Color(white: 0.15), location: 0.11),
            .init(color: Color(white: 0.19), location: 0.35),
            .init(color: Color(white: 0.22), location: 0.40),
            .init(color: Color(white: 0.28), location: 0.51),
            .init(color: Color(white: 0.33), location: 0.70),
            .init(color: Color(white: 0.29), location: 0.80),
            .init(color: Color(white: 0.20), location: 0.87),
            .init(color: Color(white: 0.16), location: 0.96),
            .init(color: Color(white: 0.25), location: 0.92),
            .init(color: Color(white: 0.35), location: 0.95),
            .init(color: Color(white: 0.12), location: 1.0)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}

var FountainGradient: LinearGradient {
    LinearGradient(
        stops: [
            .init(color: Color(white: 0.65), location: 0.0),
            .init(color: Color(white: 0.82), location: 0.2),
            .init(color: Color(white: 0.95), location: 0.45),
            .init(color: Color(white: 0.75), location: 0.7),
            .init(color: Color(white: 0.52), location: 1.0)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}

let conegradient: [Gradient.Stop] = [
    .init(color: Color(white: 0.12), location: 0.02),
    .init(color: Color(white: 0.27), location: 0.03),
    .init(color: Color(white: 0.20), location: 0.08),
    .init(color: Color(white: 0.15), location: 0.11),
    .init(color: Color(white: 0.19), location: 0.35),
    .init(color: Color(white: 0.22), location: 0.40),
    .init(color: Color(white: 0.28), location: 0.51),
    .init(color: Color(white: 0.33), location: 0.70),
    .init(color: Color(white: 0.29), location: 0.80),
    .init(color: Color(white: 0.20), location: 0.87),
    .init(color: Color(white: 0.16), location: 0.96),
    .init(color: Color(white: 0.25), location: 0.92),
    .init(color: Color(white: 0.35), location: 0.95),
    .init(color: Color(white: 0.12), location: 1.0)
]

let gradientStops: [Gradient.Stop] = [
    .init(color: Color(white: 0.32), location: 0.0),
    .init(color: Color(white: 0.22), location: 0.03),
    .init(color: Color(white: 0.19), location: 0.06),
    .init(color: Color(white: 0.15), location: 0.10),
    .init(color: Color(white: 0.19), location: 0.29),
    .init(color: Color(white: 0.22), location: 0.35),
    .init(color: Color(white: 0.28), location: 0.51),
    .init(color: Color(white: 0.33), location: 0.74),
    .init(color: Color(white: 0.29), location: 0.83),
    .init(color: Color(white: 0.21), location: 0.88),
    .init(color: Color(white: 0.18), location: 0.95),
    .init(color: Color(white: 0.20), location: 0.96),
    .init(color: Color(white: 0.25), location: 0.98),
    .init(color: Color(white: 0.30), location: 1.0)
]
