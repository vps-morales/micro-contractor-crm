//
//  ContractorCRMApp.swift
//  ContractorCRM
//
//  Created by Tito on 4/24/26.
//

import SwiftUI

@main
struct ContractorCRMApp: App {
    @StateObject private var contractorViewModel = ContractorViewModel()
    @StateObject private var jobViewModel = JobViewModel()
    @StateObject private var invoiceViewModel = InvoiceViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contractorViewModel)
                .environmentObject(jobViewModel)
                .environmentObject(invoiceViewModel)
        }
    }
}
