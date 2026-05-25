import AppKit
import MarkdownPreviewCore
import QuickLookUI

final class PreviewViewController: NSViewController, QLPreviewingController {
    private let textView = NSTextView()
    private let scrollView = NSScrollView()

    override func loadView() {
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = true
        scrollView.backgroundColor = .textBackgroundColor

        textView.isEditable = false
        textView.isSelectable = true
        textView.drawsBackground = false
        textView.textContainerInset = NSSize(width: 28, height: 24)
        textView.textContainer?.widthTracksTextView = true

        scrollView.documentView = textView
        view = scrollView
    }

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileSize = (try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? UInt64) ?? 0
                let text = try MarkdownFileReader().readText(from: url)
                let attributed: NSAttributedString

                if PreviewLimits().shouldUseSimplifiedPreview(fileSize: fileSize) {
                    attributed = NSAttributedString(string: text)
                } else {
                    let blocks = LineMarkdownParser().parse(text)
                    attributed = NativeAttributedStringRenderer().render(blocks)
                }

                DispatchQueue.main.async {
                    self.textView.textStorage?.setAttributedString(attributed)
                    handler(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    self.textView.string = "This Markdown file could not be previewed."
                    handler(nil)
                }
            }
        }
    }
}
