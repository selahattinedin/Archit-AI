import SwiftUI

struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Sol alt köşeden başla
        path.move(to: CGPoint(x: 0, y: rect.height))
        
        // Sol kenar
        path.addLine(to: CGPoint(x: 0, y: 15))
        
        // Sol üst köşe
        path.addQuadCurve(
            to: CGPoint(x: 15, y: 0),
            control: CGPoint(x: 0, y: 0)
        )
        
        // Orta üst kısım (plus buton için hafif kavis)
        path.addCurve(
            to: CGPoint(x: rect.width - 15, y: 0),
            control1: CGPoint(x: rect.width * 0.4, y: 10),
            control2: CGPoint(x: rect.width * 0.6, y: 10)
        )
        
        // Sağ üst köşe
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: 15),
            control: CGPoint(x: rect.width, y: 0)
        )
        
        // Sağ kenar
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        // Alt kenar (hafif yuvarlatılmış)
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height),
            control: CGPoint(x: rect.width * 0.5, y: rect.height - 1)
        )
        
        return path
    }
}
