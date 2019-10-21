import UIKit

@IBDesignable
class CurvedLabel: UILabel {
    // *******************************************************
    // DEFINITIONS (Because I'm not brilliant and I'll forget most this tomorrow.)
    // Radius: A straight line from the center to the circumference of a circle.
    // Circumference: The distance around the edge (outer line) the circle.
    // Arc: A part of the circumference of a circle. Like a length or section of the circumference.
    // Theta: A label or name that represents an angle.
    // Subtend: A letter has a width. If you put the letter on the circumference, the letter's width
    //          gives you an arc. So now that you have an arc (a length on the circumference) you can
    //          use that to get an angle. You get an angle when you draw a line from the center of the
    //          circle to each end point of your arc. So "subtend" means to get an angle from an arc.
    // Chord: A line segment connecting two points on a curve. If you have an arc then there is a
    //          start point and an end point. If you draw a straight line from start point to end point
    //          then you have a "chord".
    // sin: (Super simple/incomplete definition) Or "sine" takes an angle in degrees and gives you a number.
    // asin: Or "asine" takes a number and gives you an angle in degrees. Opposite of sine.
    //          More complete definition: http://www.mathsisfun.com/sine-cosine-tangent.html
    // cosine: Also takes an angle in degrees and gives you another number from using the two radiuses (radii).
    // *******************************************************

    @IBInspectable var angle: CGFloat = 1.6
    @IBInspectable var maxArc: CGFloat = 1.6
    @IBInspectable var maxWidthPerLine: CGFloat = 130.0
    @IBInspectable var clockwise: Bool = true

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let size = self.bounds.size
        context.translateBy(x: size.width / 2, y: ((size.height) / 2) )



        let lines = breakTextIntoLines()

        for (index, value) in lines.enumerated() {
            centreArcPerpendicular(text: value, yOffset: CGFloat(20*index))
        }

    }

    private func breakTextIntoLines() -> [String] {
        let text =  self.text ?? ""
        var lines = [String]()
        let textView = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: maxWidthPerLine, height: 300))
        textView.text = text

        let layoutManager = textView.layoutManager
        // go through each line fragment
        layoutManager.enumerateLineFragments(forGlyphRange: NSMakeRange(0, Int(layoutManager.numberOfGlyphs)), using: {
            (rect, usedRect, textContainer, glyphRange, stop) in

            let range = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)

            let fragment = NSString(string: text).substring(with: range)

            lines.append(fragment)
        })
        return lines
    }

    /**
     This draws the self.text around an arc of radius r,
     with the text centred at polar angle theta
     */
    func centreArcPerpendicular(text str: String, yOffset yO:CGFloat) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        //let str = self.text ?? ""
        let size = self.bounds.size
        //context.translateBy(x: -yO, y: yO )
        //context.

        let radius = getRadiusForLabel() - yO
        let l = str.count
      var attributes = [NSAttributedString.Key : Any]();
      attributes = [.font: self.font];

        let characters = Array(str); // An array of single character strings, each character in str
      var arcs: NSMutableArray = NSMutableArray(); // This will be the arcs subtended by each character
        var totalArc: CGFloat = 0 // ... and the total arc subtended by the string

        // Calculate the arc subtended by each letter and their total
      for char in str {
        let temp = String(char);
        var newArc = chordToArc(temp.size(withAttributes: attributes).width, radius: radius);
        arcs.add(newArc);
        totalArc += newArc;
      }

        // Are we writing clockwise (right way up at 12 o'clock, upside down at 6 o'clock)
        // or anti-clockwise (right way up at 6 o'clock)?
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection = clockwise ? -CGFloat(M_PI_2) : CGFloat(M_PI_2)

        // The centre of the first character will then be at
        // thetaI = theta - totalArc / 2 + arcs[0] / 2
        // But we add the last term inside the loop
        let radiansAngle = angle * .pi / 180
        var thetaI = radiansAngle - direction * totalArc / 2
      var i = 0;
      for char in str {
            thetaI += direction * (arcs.object(at: i) as! CGFloat) / 2
            // Call centre with each character in turn.
            // Remember to add +/-90º to the slantAngle otherwise
            // the characters will "stack" round the arc rather than "text flow"
            centre(text: String(char), context: context, radius: radius, angle: thetaI, slantAngle: thetaI + slantCorrection)
            // The centre of the next character will then be at
            // thetaI = thetaI + arcs[i] / 2 + arcs[i + 1] / 2
            // but again we leave the last term to the start of the next loop...
            thetaI += direction * (arcs.object(at: i) as! CGFloat) / 2
            i = i + 1;
        }
    }

    func chordToArc(_ chord: CGFloat, radius: CGFloat) -> CGFloat {
        // *******************************************************
        // Simple geometry
        // *******************************************************
        return 2 * asin(chord / (2 * radius))
    }

    /**
     This draws the String str centred at the position
     specified by the polar coordinates (r, theta)
     i.e. the x= r * cos(theta) y= r * sin(theta)
     and rotated by the angle slantAngle
    */
    func centre(text str: String, context: CGContext, radius r:CGFloat, angle theta: CGFloat, slantAngle: CGFloat) {
        // Set the text attributes
      var attributes = [NSAttributedString.Key : Any]();
      attributes = [.font: self.font];
//        let attributes = [NSForegroundColorAttributeName: self.textColor,
//                          NSFontAttributeName: self.font] as [String : Any]
        // Save the context
        context.saveGState()
        // Move the origin to the centre of the text (negating the y-axis manually)
        context.translateBy(x: r * cos(theta), y: -(r * sin(theta)))
        // Rotate the coordinate system
        context.rotate(by: -slantAngle)
        // Calculate the width of the text
      let offset = str.size(withAttributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy(x: -offset.width / 2, y: -offset.height / 2) // Move the origin to the centre of the text (negating the y-axis manually)
        // Draw the text
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        // Restore the context
        context.restoreGState()
    }

    func getRadiusForLabel() -> CGFloat {
        // Imagine the bounds of this label will have a circle inside it.
        // The circle will be as big as the smallest width or height of this label.
        // But we need to fit the size of the font on the circle so make the circle a little
        if (UIDevice.current.userInterfaceIdiom == .phone){
         return 100
        }
        return 145.0
    }
}
