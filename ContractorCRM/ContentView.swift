//
//  ContentView.swift
//  ContractorCRM
//
//  Created by Tito on 4/24/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contractorViewModel: ContractorViewModel
    @EnvironmentObject var jobViewModel: JobViewModel
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel

    var body: some View {
        TabView {
            ContractorsListView()
                .tabItem {
                    Label("Contractors", systemImage: "person.2.fill")
                }

            JobsListView()
                .tabItem {
                    Label("Jobs", systemImage: "briefcase.fill")
                }

            InvoicesListView()
                .tabItem {
                    Label("Invoices", systemImage: "doc.fill")
                }

            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
        }
        .accentColor(.blue)
    }
}

struct ContractorsListView: View {
    @EnvironmentObject var viewModel: ContractorViewModel
    @State private var showAddContractor = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.contractors) { contractor in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(contractor.name).font(.headline)
                        Text(contractor.specialty).font(.subheadline).foregroundColor(.gray)
                        Text("$\(String(format: "%.2f", contractor.hourlyRate))/hr").font(.caption).foregroundColor(.blue)
                    }
                }
                .onDelete { offsets in
                    for index in offsets {
                        viewModel.deleteContractor(viewModel.contractors[index].id)
                    }
                }
            }
            .navigationTitle("Contractors")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddContractor = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddContractor) {
                AddContractorView(isPresented: $showAddContractor)
            }
        }
    }
}

struct AddContractorView: View {
    @EnvironmentObject var viewModel: ContractorViewModel
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var specialty = ""
    @State private var hourlyRate = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                TextField("Phone", text: $phone)
                TextField("Specialty", text: $specialty)
                TextField("Hourly Rate", text: $hourlyRate).keyboardType(.decimalPad)
            }
            .navigationTitle("Add Contractor")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let rate = Double(hourlyRate) {
                            let contractor = Contractor(name: name, email: email, phone: phone, address: "", specialty: specialty, hourlyRate: rate)
                            viewModel.addContractor(contractor)
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}

struct JobsListView: View {
    @EnvironmentObject var jobViewModel: JobViewModel
    @State private var showAddJob = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(jobViewModel.jobs) { job in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(job.title).font(.headline)
                        Text(job.status.rawValue).font(.caption).foregroundColor(.gray)
                    }
                }
                .onDelete { offsets in
                    for index in offsets {
                        jobViewModel.deleteJob(jobViewModel.jobs[index].id)
                    }
                }
            }
            .navigationTitle("Jobs")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddJob = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct InvoicesListView: View {
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel
    @State private var showAddInvoice = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(invoiceViewModel.invoices) { invoice in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(invoice.invoiceNumber).font(.headline)
                        Text("$\(String(format: "%.2f", invoice.amount))").font(.subheadline).foregroundColor(.blue)
                    }
                }
                .onDelete { offsets in
                    for index in offsets {
                        invoiceViewModel.deleteInvoice(invoiceViewModel.invoices[index].id)
                    }
                }
            }
            .navigationTitle("Invoices")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddInvoice = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject var contractorViewModel: ContractorViewModel
    @EnvironmentObject var jobViewModel: JobViewModel
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Dashboard").font(.title).fontWeight(.bold)
                HStack {
                    StatCard(label: "Contractors", value: String(contractorViewModel.contractors.count))
                    StatCard(label: "Jobs", value: String(jobViewModel.jobs.count))
                    StatCard(label: "Invoices", value: String(invoiceViewModel.invoices.count))
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct StatCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Text(value).font(.title3).fontWeight(.bold)
            Text(label).font(.caption).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    ContentView()
        .environmentObject(ContractorViewModel())
        .environmentObject(JobViewModel())
        .environmentObject(InvoiceViewModel())
}
