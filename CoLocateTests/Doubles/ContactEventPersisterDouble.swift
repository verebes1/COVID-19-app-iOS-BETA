//
//  ContactEventPersisterDouble.swift
//  CoLocateTests
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation
@testable import CoLocate

class ContactEventPersisterDouble: ContactEventPersister {
    
    var items: [ContactEvent] = []
    
    func reset() {
        items = []
    }
    
}
