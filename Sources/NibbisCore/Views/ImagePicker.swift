//
//  ImagePicker.swift
//  NibbisCore
//
//  Created by Chesley Stephens on 1/15/24.
//

import SwiftUI

public struct ImagePicker: UIViewControllerRepresentable {
    
    private let targetSize: CGSize
    private let sourceType: UIImagePickerController.SourceType
    @Binding private var image: UIImage?
    
    public init(
        targetSize: CGSize,
        sourceType: UIImagePickerController.SourceType,
        image: Binding<UIImage?>
    ) {
        self.targetSize = targetSize
        self.sourceType = sourceType
        self._image = image
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

    public func makeCoordinator() -> Coordinator {
        Coordinator(targetSize: targetSize, image: $image)
    }
    
    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let targetSize: CGSize
        @Binding var image: UIImage?
        
        init(
            targetSize: CGSize,
            image: Binding<UIImage?>
        ) {
            self.targetSize = targetSize
            self._image = image
        }
        
        public func imagePickerController(
            _ picker: UIImagePickerController, didFinishPickingMediaWithInfo
            info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.editedImage] as? UIImage {
                self.image = image.scalePreservingAspectRatio(targetSize: targetSize)
            }
            picker.dismiss(animated: true)
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
