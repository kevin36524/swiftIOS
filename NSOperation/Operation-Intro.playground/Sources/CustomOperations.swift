import UIKit
import Compressor

public class TiltShiftOperation : Operation {
    public var inputImage:UIImage?
    public var outputImage:UIImage?
    
    override public func main() {
        guard let inputImage = inputImage else {
            return;
        }
        
        let mask = topAndBottomGradient(size: inputImage.size)
        outputImage = inputImage.applyBlurWithRadius(blurRadius: 10, maskImage: mask)
    }
}

public class ImageDecompressorOperation: Operation {
    public var inputImagePath: String?
    public var outputImage: UIImage?
    
    override public func main() {
        guard let inputImagePath = inputImagePath else { return }
        
        if let decompressedData = Compressor.loadCompressedFile(inputImagePath) {
            outputImage = UIImage(data: decompressedData);
        }
    }
}
