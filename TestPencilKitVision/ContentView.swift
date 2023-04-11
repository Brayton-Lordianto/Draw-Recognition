//
//  ContentView.swift
//  TestPencilKitVision
//
//  Created by Brayton Lordianto on 4/10/23.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color = Color.white
    @State var drawingTool: tool = .pen
    @State var showingSecondScreen = false
    @State var lastURL = ""
    @State var showScreen = false
    var body: some View {
        HStack {
            DrawingView(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool)
            SideCommitView(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool, showingSecondScreen: $showingSecondScreen, showScreen: $showScreen)
                .frame(width: 400)
        }
        .ignoresSafeArea()
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
