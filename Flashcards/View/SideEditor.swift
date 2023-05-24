//
//  SideEditor.swift
//  Flashcards
//
//  Created by david-swift on 14.05.23.
//

import SwiftUI

/// An editor for a side.
struct SideEditor: View {

    /// The side.
    @Binding var side: Side
    /// Whether the image popover is visible.
    @State private var imagePopoverVisible = false
    /// Whether the help popover is visible.
    @State private var helpPopoverVisible = false

    /// The aspect ratio of the placeholder image.
    let placeholderAspectRatio: CGFloat = 2
    /// The width of the text field in a popover.
    let popoverTextFieldWidth: CGFloat = 200

    /// The view's body.
    var body: some View {
        VStack {
            AsyncImage(url: .init(string: side.imageURL)) { image in
                if let image = image.image {
                    image.resizable().aspectRatio(contentMode: .fit)
                } else {
                    Rectangle()
                        .foregroundStyle(.regularMaterial)
                        .aspectRatio(placeholderAspectRatio, contentMode: .fit)
                }
            }
            .cornerRadius(.colibriCornerRadius)
            .overlay(alignment: .bottom) { imageOverlay }
            Spacer()
            TextField(
                String(localized: .init(
                    "Title",
                    comment: "FlashcardEditor (Title text field)"
                )),
                text: $side.title,
                axis: .vertical
            )
                .bold()
            TextField(
                String(localized: .init(
                    "Description",
                    comment: "FlashcardEditor (Description text field)"
                )),
                text: $side.description,
                axis: .vertical
            )
        }
    }

    /// The buttons for toggling the image and help popover's state and the popovers.
    private var imageOverlay: some View {
        HStack {
            Button {
                imagePopoverVisible.toggle()
            } label: {
                Image(systemSymbol: .photo)
                    .imageOverlayButton()
                    .accessibilityLabel(.init(
                        "Edit the image URL",
                        comment: "SideEditor (Accessibility label of image URL button)"
                    ))
            }
            .popover(isPresented: $imagePopoverVisible) {
                imagePopover
            }
            Button {
                helpPopoverVisible.toggle()
            } label: {
                Image(systemSymbol: .questionmarkCircle)
                    .imageOverlayButton()
                    .accessibilityLabel(.init(
                        "Edit the help text",
                        comment: "SideEditor (Accessibility label of help text button)"
                    ))
            }
            .popover(isPresented: $helpPopoverVisible) {
                helpPopover
            }
        }
        .buttonStyle(.plain)
        .padding(.bottom)
    }

    /// Popover for editing the image URL.
    private var imagePopover: some View {
        TextField(.init("Image URL", comment: "Detail (Image URL text field)"), text: $side.imageURL)
            .frame(width: popoverTextFieldWidth)
            .padding()
    }

    /// Popover for editing the help text.
    private var helpPopover: some View {
        TextField(.init("Help Message", comment: "Detail (Help message text field)"), text: $side.help)
            .frame(width: popoverTextFieldWidth)
            .padding()
    }

}

/// Previews for the ``SideEditor``.
struct SideEditor_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        SideEditor(side: .constant(.init()))
    }

}
