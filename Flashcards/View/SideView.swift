//
//  SideView.swift
//  Flashcards
//
//  Created by david-swift on 16.05.23.
//

import SwiftUI

/// A view for one or multiple related sides in the study mode.
struct SideView: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// The sides.
    var sides: [Side]

    /// Font size of the help icon.
    let helpFontSize: CGFloat = 20
    /// Half a circle in degrees.
    let halfCircle: CGFloat = 180
    /// The intensity of the turn effect on the y axis.
    let yAxisIntensity: CGFloat = 10
    /// Opacity of the shadow.
    let shadowOpacity: CGFloat = 0.1
    /// Radius of the shadow.
    let shadowRadius: CGFloat = 30
    /// Aspect ratio of a flashcard.
    let cardAspectRatio = 1.5

    /// The side centered at the moment.
    var side: Side {
        if let side = sides[safe: viewModel.stackIndex] {
            return side
        } else {
            Task { @MainActor in
                if viewModel.stackIndex >= sides.count {
                    viewModel.stackIndex = sides.count - 1
                }
            }
            return .init()
        }
    }

    /// The view's body.
    var body: some View {
        HStack {
            previousButton
            VStack {
                Spacer()
                AsyncImage(url: .init(string: side.imageURL)) { image in
                    image.image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(.colibriCornerRadius)
                        .padding()
                }
                Text(LocalizedStringResource(stringLiteral: side.title))
                    .font(.title)
                if !side.description.isEmpty {
                    Text(LocalizedStringResource(stringLiteral: side.description))
                        .padding(.top, 1)
                }
                Spacer()
            }
            Spacer()
            nextButton
        }
        .buttonStyle(.link)
        .overlay(alignment: .topTrailing) {
            if !side.help.isEmpty {
                Button {
                    viewModel.showHelp.toggle()
                } label: {
                    Image(systemSymbol: .questionmarkCircle)
                        .accessibilityLabel(.init(
                            "Show Help",
                            comment: "SideView (Accessibility label for show help button)"
                        ))
                        .font(.system(size: helpFontSize))
                        .padding()
                }
                .buttonStyle(.plain)
                .popover(isPresented: $viewModel.showHelp) {
                    Text(side.help)
                        .padding()
                }
            }
        }
        .animation(.default, value: viewModel.stackIndex)
        .rotation3DEffect(
            !viewModel.ask ? Angle(degrees: halfCircle) : Angle(degrees: 0),
            axis: (x: CGFloat(0), y: CGFloat(yAxisIntensity), z: CGFloat(0))
        )
        .minimumScaleFactor(0)
        .padding()
        .background(.bar, in: RoundedRectangle(cornerRadius: .colibriCornerRadius))
        .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius)
        .padding()
        .aspectRatio(cardAspectRatio, contentMode: .fit)
    }

    /// The view with the button for navigating back.
    @ViewBuilder private var previousButton: some View {
        if sides.first?.id != side.id {
            Button {
                viewModel.stackIndex -= 1
            } label: {
                Image(systemSymbol: .chevronLeft)
                    .padding()
                    .accessibilityLabel(.init(
                        "Previous Side",
                        comment: "SideView (Accessibility label for previous side button)"
                    ))
            }
        }
        Spacer()
    }

    /// The view with the button for navigating to the next side.
    @ViewBuilder private var nextButton: some View {
        if sides.last?.id != side.id {
            Button {
                viewModel.stackIndex += 1
            } label: {
                Image(systemSymbol: .chevronRight)
                    .padding()
                    .accessibilityLabel(.init(
                        "Next Side",
                        comment: "SideView (Accessibility label for next side button)"
                    ))
            }
        }
    }

}

/// Previews for the ``SideView``.
struct SideView_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        SideView(sides: [.init()])
    }

}
