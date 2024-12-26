//
//  ImgPicker.swift
//  SwiftUI&KIT
//
//  Created by 이미진 on 11/7/24.
//
//
//import SwiftUI
//import PhotosUI
//
//class ImagePickerCoordinator:NSObject, PHPickerViewControllerDelegate {
//    let parent:ImgPicker
//    init(parent:ImgPicker){
//        self.parent = parent
//    }
//    
//    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        
//        guard let itemProvider = results.first?.itemProvider else {return}
//        if itemProvider.canLoadObject(ofClass: UIImage.self) {
//            itemProvider.loadObject(ofClass: UIImage.self) {image, error in
//                self.parent.image = image as? UIImage
//            }
//        }
//        picker.dismiss(animated:true)
//    }
//}
//
//struct ImgPicker: UIViewControllerRepresentable {
//    @Binding var image:UIImage?
//    func makeUIViewController(context: Context) ->PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//        config.selectionLimit = 1
//        let picker = PHPickerViewController(configuration: config)
//        return picker
//    }
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//        uiViewController.delegate = context.coordinator
//    }
//    func makeCoordinator() -> ImagePickerCoordinator {
//        ImagePickerCoordinator(parent: self)
//    }
//}
//
//struct ImagePickerView:View {
//    @State var isPresented:Bool = false
//    @State var aImage:UIImage?
//    var body: some View {
//        VStack{
//            if let aImage{
//                Image(uiImage: aImage).resizable().frame(width: 300, height: 300)
//            }
//            Button("사진 선택") {
//                isPresented.toggle()
//            }.sheet(isPresented: $isPresented) {
//                ImgPicker(image: $aImage)
//            }
//        }
//    }
//}
//
//#Preview {
//    ImagePickerView()
//}

import SwiftUI
import UIKit
import SVProgressHUD

struct ImagePicker: View {
    @Binding var image: UIImage?

    var body: some View {
        ImagePickerController(image: $image)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerController

        init(parent: ImagePickerController) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
