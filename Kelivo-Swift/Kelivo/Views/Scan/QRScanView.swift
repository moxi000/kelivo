import SwiftUI

#if os(iOS)
import AVFoundation
import UIKit

/// QR code scanner view using AVCaptureSession on iOS.
struct QRScanView: View {
    @Environment(\.dismiss) private var dismiss
    let onScanned: (String) -> Void

    @State private var scannedValue: String?
    @State private var isTorchOn = false
    @State private var cameraPermissionGranted = false

    var body: some View {
        NavigationStack {
            ZStack {
                if cameraPermissionGranted {
                    QRCameraPreview(onScanned: handleScan, isTorchOn: $isTorchOn)
                        .ignoresSafeArea()
                } else {
                    ContentUnavailableView {
                        Label(String(localized: "Camera Access Required"), systemImage: "camera.fill")
                    } description: {
                        Text(String(localized: "Please grant camera access in Settings to scan QR codes."))
                    } actions: {
                        Button(String(localized: "Open Settings")) {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }

                // Scan instruction overlay
                VStack {
                    Spacer()
                    Text(String(localized: "Point the camera at a QR code"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.bottom, 40)
                }
            }
            .navigationTitle(String(localized: "Scan QR Code"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isTorchOn.toggle()
                    } label: {
                        Image(systemName: isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                    }
                }
            }
            .onAppear {
                checkCameraPermission()
            }
        }
    }

    private func handleScan(_ value: String) {
        guard scannedValue == nil else { return }
        scannedValue = value
        onScanned(value)
        dismiss()
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraPermissionGranted = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    cameraPermissionGranted = granted
                }
            }
        default:
            cameraPermissionGranted = false
        }
    }
}

/// UIViewRepresentable wrapper for AVCaptureSession-based QR scanning.
private struct QRCameraPreview: UIViewRepresentable {
    let onScanned: (String) -> Void
    @Binding var isTorchOn: Bool

    func makeUIView(context: Context) -> QRScannerUIView {
        let view = QRScannerUIView()
        view.onScanned = onScanned
        return view
    }

    func updateUIView(_ uiView: QRScannerUIView, context: Context) {
        uiView.setTorch(isTorchOn)
    }
}

private class QRScannerUIView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    var onScanned: ((String) -> Void)?
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCamera()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }

    private func setupCamera() {
        let session = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let output = AVCaptureMetadataOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: .main)
            output.metadataObjectTypes = [.qr]
        }

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = bounds
        self.layer.addSublayer(layer)

        self.captureSession = session
        self.previewLayer = layer

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }

    func setTorch(_ on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        try? device.lockForConfiguration()
        device.torchMode = on ? .on : .off
        device.unlockForConfiguration()
    }

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let value = object.stringValue, !value.isEmpty else { return }
        captureSession?.stopRunning()
        onScanned?(value)
    }

    deinit {
        captureSession?.stopRunning()
    }
}
#else
/// macOS placeholder — QR scanning is iOS only.
struct QRScanView: View {
    @Environment(\.dismiss) private var dismiss
    let onScanned: (String) -> Void

    var body: some View {
        ContentUnavailableView {
            Label(String(localized: "QR Scanning"), systemImage: "qrcode.viewfinder")
        } description: {
            Text(String(localized: "QR code scanning is only available on iOS."))
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Close")) { dismiss() }
            }
        }
    }
}
#endif

#Preview {
    QRScanView { value in
        print("Scanned: \(value)")
    }
}
