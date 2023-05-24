//
//  StudyView.swift
//  Flashcards
//
//  Created by david-swift on 15.05.23.
//

import SwiftUI

/// The view for studying a set.
struct StudyView: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// The dragging offset of the current card.
    @State private var dragOffset: CGSize = .zero
    /// The set.
    @Binding var set: CardSet

    /// Half a circle in degrees.
    let halfCircle: CGFloat = 180
    /// The intensity of the turn effect on the y axis.
    let yAxisIntensity: CGFloat = 10
    /// The divisor for the rotation effect.
    let rotationEffectDivisor: CGFloat = 50
    /// Opacity of the background color.
    let backgroundOpacity: CGFloat = 0.8
    /// The dragging threshold in both directions.
    let dragThreshold: CGFloat = 200

    /// The view's body.
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                if let flashcard = set.flashcards[id: set.studyID] {
                    if viewModel.showFront {
                        SideView(sides: [flashcard.front])
                    } else {
                        SideView(sides: flashcard.back)
                    }
                } else {
                    Text(.init(
                        "There are no flashcards in this set.",
                        comment: "StudyView (Error when no flashcards are available)"
                    ))
                }
                Spacer()
            }
            Spacer()
        }
        .onTapGesture {
            viewModel.ask.toggle()
        }
        .accessibilityAddTraits(.isButton)
        .rotation3DEffect(
            !viewModel.ask ? Angle(degrees: halfCircle) : Angle(degrees: 0),
            axis: (x: CGFloat(0), y: CGFloat(yAxisIntensity), z: CGFloat(0))
        )
        .offset(dragOffset)
        .rotationEffect(.degrees(dragOffset.width / rotationEffectDivisor))
        .background((right ? Color.green : (left ? .red : .clear)).opacity(backgroundOpacity))
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { _ in
                    if left {
                        set.wrong()
                        viewModel.ask = true
                    } else if right {
                        set.right()
                        viewModel.ask = true
                    }
                    dragOffset = .zero
                }
        )
        .animation(.default, value: viewModel.showFront)
        .animation(.default, value: dragOffset)
    }

    /// Whether the dragging offset is in the "correct" area.
    private var right: Bool {
        dragOffset.width > dragThreshold
    }

    /// Whether the dragging offset is in the "wrong" area.
    private var left: Bool {
        dragOffset.width < -dragThreshold
    }

}

/// Previews for the ``StudyView``.
struct StudyView_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        StudyView(set: .constant(.init()))
    }

}
