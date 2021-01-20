// Live.swift
// Copyright (c) 2021 Joe Blau

import Combine
import ComposableArchitecture
import Foundation
import WebKit

private let source = """
var speedTarget = document.querySelector('#speed-value');
var uploadTarget = document.querySelector('#upload-value');

var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {

        if (mutation.target.id == "speed-value") {

            if (mutation.attributeName == "class") {
            window.webkit.messageHandlers.notification.postMessage({ type: "down-done", value: "", units: "" });
            } else {
                let units = document.querySelector("#speed-units").innerText
                let value = mutation.addedNodes.item(0).data
                window.webkit.messageHandlers.notification.postMessage({ type: "down", value: value, units: units });
            }
        }

        if (mutation.target.id == "upload-value") {
            if (mutation.attributeName == "class") {
                window.webkit.messageHandlers.notification.postMessage({ type: "up-done", value: "", units: "" });
            } else {
                let units = document.querySelector("#upload-units").innerText
                let value = mutation.addedNodes.item(0).data
                window.webkit.messageHandlers.notification.postMessage({ type: "up", value: value, units: units });
            }
        }
    });
});

var config = { attributes: true, childList: true, characterData: true }

observer.observe(speedTarget, config);
observer.observe(uploadTarget, config);
"""

public extension FastManager {
    static let live: FastManager = { () -> FastManager in
        var manager = FastManager()

        manager.create = { id in
            Effect.run { subscriber in
                let delegate = FastManagerDelegate(subscriber)
                let userContent = WKUserContentController()
                let config = WKWebViewConfiguration()
                let userScript = WKUserScript(source: source,
                                              injectionTime: .atDocumentEnd,
                                              forMainFrameOnly: true)
                userContent.addUserScript(userScript)
                userContent.add(delegate, name: "notification")

                config.userContentController = userContent
                let webview = WKWebView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),
                                        configuration: config)

                dependencies[id] = Dependencies(delegate: delegate,
                                                userContent: userContent,
                                                config: config,
                                                webView: webview,
                                                subscriber: subscriber)
                return AnyCancellable {
                    dependencies[id] = nil
                }
            }
        }

        manager.destroy = { id in
            .fireAndForget {
                dependencies[id]?.subscriber.send(completion: .finished)
                dependencies[id] = nil
            }
        }

        manager.startTest = { id in
            .fireAndForget {
                dependencies[id]?.webView.load(URLRequest(url: URL(string: "https://fast.com")!))
            }
        }

        manager.stopTest = { id in
            .fireAndForget {
                dependencies[id]?.webView.stopLoading()
            }
        }
        return manager
    }()
}

// MARK: - Dependencies

private struct Dependencies {
    let delegate: FastManagerDelegate
    let userContent: WKUserContentController
    let config: WKWebViewConfiguration
    let webView: WKWebView
    let subscriber: Effect<FastManager.Action, Never>.Subscriber
}

private var dependencies: [AnyHashable: Dependencies] = [:]

// MARK: - Delegate

private class FastManagerDelegate: NSObject, WKScriptMessageHandler {
    let subscriber: Effect<FastManager.Action, Never>.Subscriber

    init(_ subscriber: Effect<FastManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        subscriber.send(.didReceive(message: message))
    }
}
