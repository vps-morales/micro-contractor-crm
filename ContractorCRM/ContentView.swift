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
    @EnvironmentObject var contractorViewModel: ContractorViewModel
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
            .sheet(isPresented: $showAddJob) {
                AddJobView(isPresented: $showAddJob)
            }
        }
    }
}

struct AddJobView: View {
    @EnvironmentObject var jobViewModel: JobViewModel
    @EnvironmentObject var contractorViewModel: ContractorViewModel
    @Binding var isPresented: Bool
    @State private var selectedContractor: Contractor?
    @State private var title = ""
    @State private var description = ""
    @State private var estimatedHours = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Contractor") {
                    Picker("Select Contractor", selection: $selectedContractor) {
                        Text("None").tag(nil as Contractor?)
                        ForEach(contractorViewModel.contractors) { contractor in
                            Text(contractor.name).tag(contractor as Contractor?)
                        }
                    }
                }
                Section("Job Details") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    TextField("Est. Hours", text: $estimatedHours).keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Job")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let contractor = selectedContractor, let hours = Double(estimatedHours) {
                            let job = Job(contractorId: contractor.id, title: title, description: description, estimatedHours: hours)
                            jobViewModel.addJob(job)
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}

struct InvoicesListView: View {
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel
    @EnvironmentObject var contractorViewModel: ContractorViewModel
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
            .sheet(isPresented: $showAddInvoice) {
                AddInvoiceView(isPresented: $showAddInvoice)
            }
        }
    }
}

struct AddInvoiceView: View {
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel
    @EnvironmentObject var contractorViewModel: ContractorViewModel
    @Binding var isPresented: Bool
    @State private var selectedContractor: Contractor?
    @State private var invoiceNumber = ""
    @State private var amount = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Contractor") {
                    Picker("Select Contractor", selection: $selectedContractor) {
                        Text("None").tag(nil as Contractor?)
                        ForEach(contractorViewModel.contractors) { contractor in
                            Text(contractor.name).tag(contractor as Contractor?)
                        }
                    }
                }
                Section("Invoice Details") {
                    TextField("Invoice Number", text: $invoiceNumber)
                    TextField("Amount ($)", text: $amount).keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Invoice")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let contractor = selectedContractor, let amt = Double(amount) {
                            let invoice = Invoice(contractorId: contractor.id, jobIds: [], invoiceNumber: invoiceNumber, amount: amt)
                            invoiceViewModel.addInvoice(invoice)
                            isPresented = false
                        }
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
