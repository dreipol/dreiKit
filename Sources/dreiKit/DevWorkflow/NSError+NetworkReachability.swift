//
//  String+Tools.swift
//  dreiKit
//
//  Created by Nils Becker on 27.09.21.
//  Copyright © 2019 dreipol. All rights reserved.
//

private let temporaryNetworkErrorCodes: Set<Int> = [NSURLErrorTimedOut,
                                          NSURLErrorInternationalRoamingOff,
                                          NSURLErrorCancelled,
                                          NSURLErrorCannotConnectToHost,
                                          NSURLErrorNetworkConnectionLost,
                                          NSURLErrorNotConnectedToInternet,
                                          NSURLErrorCallIsActive,
                                          NSURLErrorDataNotAllowed,
                                          NSURLErrorBackgroundSessionWasDisconnected,
]

public extension NSError {
    var isTemporaryNetworkError: Bool {
        domain == NSURLErrorDomain && temporaryNetworkErrorCodes.contains(code)
    }
}
