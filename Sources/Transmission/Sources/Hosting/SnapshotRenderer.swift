//
// Copyright (c) Nathan Tannar
//

#if os(iOS)

import SwiftUI
import Turbocharger

public enum SnapshotRendererColorSpace {
    // The extended linear sRGB working color space.
    case extendedLinear

    // The linear sRGB working color space.
    case linear

    // The non-linear sRGB working color space.
    case nonLinear

    func toCoreGraphics() -> CGColorSpace {
        switch self {
        case .extendedLinear:
            return CGColorSpace(name: CGColorSpace.extendedLinearSRGB)!
        case .linear:
            return CGColorSpace(name: CGColorSpace.linearSRGB)!
        case .nonLinear:
            return CGColorSpace(name: CGColorSpace.sRGB)!
        }
    }
}

/// A backwards compatible port of `ImageRenderer`
///
/// See Also:
///  - ``SnapshotItemProvider``
@MainActor
public final class SnapshotRenderer<Content: View>: ObservableObject {

    public var content: Content {
        get { host.content.content }
        set {
            host.content.content = newValue
            objectWillChange.send()
        }
    }

    public var scale: CGFloat {
        get { format.scale }
        set {
            format.scale = newValue
            host.content.modifier.scale = scale
        }
    }

    public var isOpaque: Bool {
        get { format.opaque }
        set {
            format.opaque = newValue
            host.layer.isOpaque = newValue
        }
    }

    public var colorSpace: SnapshotRendererColorSpace = .nonLinear

    public var proposedSize: Turbocharger.ProposedSize = .unspecified

    private let format: UIGraphicsImageRendererFormat
    private let host: HostingView<ModifiedContent<Content, SnapshotRendererModifier>>

    public init(content: Content) {
        let format = UIGraphicsImageRendererFormat()
        self.format = format
        let host = HostingView(
            content: content.modifier(
                SnapshotRendererModifier(scale: format.scale)
            )
        )
        host.disablesSafeArea = true
        self.host = host
    }

    public func render<Result>(
        rasterizationScale: CGFloat = 1,
        renderer: (CGSize, (CGContext) -> Void) -> Result
    ) -> Result {
        let size: CGSize = {
            let intrinsicContentSize = host.intrinsicContentSize
            return CGSize(
                width: proposedSize.width ?? intrinsicContentSize.width,
                height: proposedSize.height ?? intrinsicContentSize.height
            )
        }()
        host.frame = CGRect(origin: .zero, size: size)
        host.layer.rasterizationScale = rasterizationScale
        host.render()
        return renderer(host.frame.size, { context in
            host.layer.render(in: context)
        })
    }

    public var cgImage: CGImage? {
        render { size, callback in
            let context = CGContext(
                data: nil,
                width: Int(size.width),
                height: Int(size.height),
                bitsPerComponent: 8,
                bytesPerRow: 0, // Calculated automatically
                space: colorSpace.toCoreGraphics(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )
            guard let context else {
                return nil
            }
            context.concatenate(CGAffineTransformMake(1, 0, 0, -1, 0, CGFloat(context.height)))
            callback(context)
            let image = context.makeImage()
            return image
        }
    }

    public var uiImage: UIImage? {
        render { size, callback in
            let renderer = UIGraphicsImageRenderer(size: size, format: format)
            return renderer.image { context in
                callback(context.cgContext)
            }
        }
    }
}

private struct SnapshotRendererModifier: ViewModifier {
    var scale: CGFloat

    func body(content: Content) -> some View {
        content.environment(\.displayScale, scale)
    }
}

#endif
