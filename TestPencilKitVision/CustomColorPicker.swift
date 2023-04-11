//
//  CustomColorPicker.swift
//  
//
//  Created by Brayton Lordianto
//

import SwiftUI
import PencilKit

struct CustomColorPickerSample: View {
    @State private var selectedColor = Color.blue
    @State var isDraw: tool = .pen
    var body: some View {
        ZStack {
            CustomColorPicker(selectedColor: $selectedColor, drawingTool: $isDraw)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CanvasMenu: View {
    @Binding var toolSelection: tool
    @Binding var color: Color
    @Binding var canvas: PKCanvasView
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Color")
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .glow(color: .red, radius: 1.4)
            HStack(spacing: 0) {
                CustomColorPicker(selectedColor: $color, drawingTool: $toolSelection)
            }
            
            Text("Tools")
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .glow(color: .red, radius: 1.4)
                .padding(.bottom)
            toolSection()
        }
        .padding(30)
        .frame(width: 135)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("MenuColor"))
        }
    }
    
    func clearSelection() -> some View  {
        Button(action: {
            canvas.drawing = PKDrawing()
        }) {
            VStack {
                Image(systemName: "trash")
                Text("Clear")
            }
        }
        .foregroundColor(.red)
    }
    
    func singleTool(label: String, imageName: String, associatedTool: tool) -> some View {
        var imgName: String {
            if associatedTool == .pen && toolSelection == .pen {
                return "pencil"
            }
            return toolSelection == associatedTool ? "\(imageName).fill" : imageName
        }
        return AnyView(Button(action: {
            toolSelection = associatedTool
        }) {
            VStack {
                Image(systemName: imgName)
            }
        }
            .padding(.bottom)
        )
    }
    
    func downloadImageButton() -> some View {
        Button(action: {
            // Create a new graphics context with a black background color
            UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, false, 1.0)
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(UIColor.black.cgColor)
            context.fill(canvas.bounds)

            // Draw the canvas image onto the context
            canvas.drawing.image(from: canvas.bounds, scale: 1).draw(in: canvas.bounds)

            // Get the resulting image from the context
            let image = UIGraphicsGetImageFromCurrentImageContext()!

            // End the context
            UIGraphicsEndImageContext()

            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }) {
            VStack {
                Image(systemName: "square.and.arrow.down.fill")
                Text("Save")
            }
        }
    }
    
    func toolSection() -> some View {
        VStack {
            singleTool(label: "pen", imageName: "pencil.tip", associatedTool: .pen)
            HStack {
                singleTool(label: "whole eraser", imageName: "circle", associatedTool: .wholeEraser)
                singleTool(label: "partial eraser", imageName: "eraser", associatedTool: .partialEraser)
            }
            clearSelection()
            downloadImageButton()
        }
    }
}

struct CustomColorPicker: View {
    @Binding var selectedColor: Color
    @Binding var drawingTool: tool
    let colors: [Color] = [.white,
                           .purple,
                           .red,
                           .orange]
    let colors2: [Color] = [.yellow,
                            .green,
                            .pink,
                            .cyan]
    let colors3: [Color] = [.mint,
                            .indigo,
                            .teal,
                            .blue]
    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 20) {
                ForEach(colors, id: \.self) { color in
                    button(color: color)
                }
            }
            VStack(spacing: 20) {
                ForEach(colors2, id: \.self) { color in
                    button(color: color)
                }
            }
            VStack(spacing: 20) {
                ForEach(colors3, id: \.self) { color in
                    button(color: color)
                }
            }
        }
    }
    
    func button(color: Color) -> some View {
        Button(action: {
            self.selectedColor = color
            self.drawingTool = .pen
        }) {
            Image(systemName: self.selectedColor == color ? "checkmark.circle.fill" : "circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: self.selectedColor == color ? 3 : 0)
                )
        }.accentColor(color)
    }
    
}

struct CustomColorPickerSample_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPickerSample()
    }
}
