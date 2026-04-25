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
            ZStack {
                Color(.systemGray6).ignoresSafeArea()

                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.contractors) { contractor in
                            ContractorCard(contractor: contractor)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete { offsets in
                            for index in offsets {
                                viewModel.deleteContractor(viewModel.contractors[index].id)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Contractors")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddContractor = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddContractor) {
                AddContractorView(isPresented: $showAddContractor)
            }
        }
    }
}

struct ContractorCard: View {
    let contractor: Contractor

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(contractor.name)
                        .font(.system(.headline, design: .default))
                        .foregroundColor(.black)
                    Text(contractor.specialty)
                        .font(.system(.caption, design: .default))
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.2f", contractor.hourlyRate))")
                        .font(.system(.headline, design: .default))
                        .foregroundColor(.blue)
                    Text("per hour")
                        .font(.system(.caption2, design: .default))
                        .foregroundColor(.gray)
                }
            }

            Divider()

            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                    Text(contractor.phone)
                        .font(.system(.caption, design: .default))
                        .foregroundColor(.gray)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                    Text(contractor.email)
                        .font(.system(.caption, design: .default))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        .padding(.vertical, 6)
        .padding(.horizontal)
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

    var isValid: Bool {
        !name.isEmpty && !email.isEmpty && !specialty.isEmpty && !hourlyRate.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()

                Form {
                    Section("Basic Information") {
                        TextField("Full Name", text: $name)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                        TextField("Phone", text: $phone)
                            .keyboardType(.phonePad)
                    }

                    Section("Professional Details") {
                        TextField("Specialty", text: $specialty)
                        TextField("Hourly Rate ($)", text: $hourlyRate)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Contractor")
            .navigationBarTitleDisplayMode(.inline)
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
                    .disabled(!isValid)
                    .fontWeight(.semibold)
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
            ZStack {
                Color(.systemGray6).ignoresSafeArea()

                List {
                    ForEach(jobViewModel.jobs) { job in
                        JobCard(job: job, contractor: contractorViewModel.getContractor(by: job.contractorId))
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            jobViewModel.deleteJob(jobViewModel.jobs[index].id)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Jobs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddJob = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddJob) {
                AddJobView(isPresented: $showAddJob)
            }
        }
    }
}

struct JobCard: View {
    let job: Job
    let contractor: Contractor?

    var statusColor: Color {
        switch job.status {
        case .pending: return Color(.systemOrange)
        case .inProgress: return Color(.systemBlue)
        case .completed: return Color(.systemGreen)
        case .cancelled: return Color(.systemRed)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(job.title)
                        .font(.system(.headline, design: .default))
                        .foregroundColor(.black)
                    if let contractor = contractor {
                        Text(contractor.name)
                            .font(.system(.caption, design: .default))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Label(job.status.rawValue, systemImage: "circle.fill")
                    .font(.system(.caption, design: .default))
                    .foregroundColor(statusColor)
            }

            Divider()

            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                    Text("\(String(format: "%.1f", job.estimatedHours))h")
                        .font(.system(.caption, design: .default))
                        .foregroundColor(.gray)
                }

                Spacer()

                if let contractor = contractor {
                    Text("$\(String(format: "%.2f", job.estimatedHours * contractor.hourlyRate))")
                        .font(.system(.caption, design: .default))
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        .padding(.vertical, 6)
        .padding(.horizontal)
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

    var isValid: Bool {
        selectedContractor != nil && !title.isEmpty && !estimatedHours.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()

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
                        TextField("Job Title", text: $title)
                        TextField("Description", text: $description)
                    }

                    Section("Estimate") {
                        TextField("Estimated Hours", text: $estimatedHours)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Job")
            .navigationBarTitleDisplayMode(.inline)
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
                    .disabled(!isValid)
                    .fontWeight(.semibold)
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
            ZStack {
                Color(.systemGray6).ignoresSafeArea()

                List {
                    ForEach(invoiceViewModel.invoices) { invoice in
                        InvoiceCard(invoice: invoice, contractor: contractorViewModel.getContractor(by: invoice.contractorId))
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            invoiceViewModel.deleteInvoice(invoiceViewModel.invoices[index].id)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Invoices")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddInvoice = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddInvoice) {
                AddInvoiceView(isPresented: $showAddInvoice)
            }
        }
    }
}

struct InvoiceCard: View {
    let invoice: Invoice
    let contractor: Contractor?

    var statusColor: Color {
        switch invoice.paymentStatus {
        case .draft: return Color(.systemGray)
        case .sent: return Color(.systemBlue)
        case .paid: return Color(.systemGreen)
        case .overdue: return Color(.systemRed)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(invoice.invoiceNumber)
                        .font(.system(.headline, design: .default))
                        .foregroundColor(.black)
                    if let contractor = contractor {
                        Text(contractor.name)
                            .font(.system(.caption, design: .default))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.2f", invoice.amount))")
                        .font(.system(.headline, design: .default))
                        .foregroundColor(.blue)
                }
            }

            Divider()

            HStack(spacing: 16) {
                Label(invoice.paymentStatus.rawValue, systemImage: "circle.fill")
                    .font(.system(.caption, design: .default))
                    .foregroundColor(statusColor)

                Spacer()

                Text("Due: \(invoice.dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.system(.caption, design: .default))
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        .padding(.vertical, 6)
        .padding(.horizontal)
    }
}

struct AddInvoiceView: View {
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel
    @EnvironmentObject var contractorViewModel: ContractorViewModel
    @Binding var isPresented: Bool
    @State private var selectedContractor: Contractor?
    @State private var invoiceNumber = ""
    @State private var amount = ""

    var isValid: Bool {
        selectedContractor != nil && !invoiceNumber.isEmpty && !amount.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()

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
                        TextField("Amount ($)", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Invoice")
            .navigationBarTitleDisplayMode(.inline)
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
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject var contractorViewModel: ContractorViewModel
    @EnvironmentObject var jobViewModel: JobViewModel
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel

    var activeJobs: [Job] {
        jobViewModel.jobs.filter { $0.status == .inProgress }
    }

    var totalRevenue: Double {
        invoiceViewModel.invoices
            .filter { $0.paymentStatus == .paid }
            .reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Dashboard")
                                    .font(.system(.title2, design: .default))
                                    .fontWeight(.bold)
                                Text("Overview & Analytics")
                                    .font(.system(.caption, design: .default))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)

                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                DashboardStatCard(
                                    icon: "person.2.fill",
                                    label: "Contractors",
                                    value: String(contractorViewModel.contractors.count),
                                    color: .blue
                                )

                                DashboardStatCard(
                                    icon: "briefcase.fill",
                                    label: "Active Jobs",
                                    value: String(activeJobs.count),
                                    color: .orange
                                )
                            }

                            HStack(spacing: 12) {
                                DashboardStatCard(
                                    icon: "doc.fill",
                                    label: "Total Invoices",
                                    value: String(invoiceViewModel.invoices.count),
                                    color: .purple
                                )

                                DashboardStatCard(
                                    icon: "dollarsign.circle.fill",
                                    label: "Total Revenue",
                                    value: "$\(String(format: "%.0f", totalRevenue))",
                                    color: .green
                                )
                            }
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DashboardStatCard: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(.title3, design: .default))
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text(label)
                    .font(.system(.caption, design: .default))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 120)
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ContentView()
        .environmentObject(ContractorViewModel())
        .environmentObject(JobViewModel())
        .environmentObject(InvoiceViewModel())
}
