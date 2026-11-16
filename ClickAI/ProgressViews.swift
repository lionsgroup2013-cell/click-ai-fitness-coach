import Charts
import SwiftUI

struct ProgressViewScreen: View {
    @Environment(AppStore.self) private var store
    @State private var period = 1

    private var chartWeights: [WeightEntry] {
        if period == 0 { return Array(store.current.weights.suffix(4)) }
        return store.current.weights
    }

    private var weightDelta: Double {
        guard let first = chartWeights.first, let last = chartWeights.last else { return 0 }
        return last.kilograms - first.kilograms
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                title
                periodPicker
                weightCard
                activityGrid
                monthReport
                achievements
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 28)
        }
        .scrollIndicators(.hidden)
        .cfScreen()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ProfileSwitcher()
            }
        }
    }

    private var title: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("ДИНАМИКА")
                .cfEyebrow()
            Text("Прогресс")
                .cfDisplayTitle()
            Text("Тренды, замеры и выполненные цели")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(CFColor.secondary)
        }
        .padding(.top, 8)
    }

    private var periodPicker: some View {
        HStack(spacing: 6) {
            ForEach(["Неделя", "Месяц", "3 месяца"], id: \.self) { label in
                let index = ["Неделя", "Месяц", "3 месяца"].firstIndex(of: label) ?? 0
                Button {
                    period = index
                } label: {
                    Text(label)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(period == index ? CFColor.background : CFColor.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(period == index ? CFColor.accent : CFColor.card)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var weightCard: some View {
        CFCard {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ВЕС")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .tracking(0.8)
                            .foregroundStyle(CFColor.secondary)
                        Text("\(store.current.currentWeight.formatted(.number.precision(.fractionLength(1)))) кг")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        HStack(spacing: 4) {
                            Image(systemName: weightDelta >= 0 ? "arrow.up.right" : "arrow.down.right")
                            Text("\(abs(weightDelta).formatted(.number.precision(.fractionLength(1)))) кг за период")
                        }
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(weightDelta >= 0 ? CFColor.accent : CFColor.blue)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("ЦЕЛЬ")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(CFColor.secondary)
                        Text("\(store.current.targetWeight.formatted(.number.precision(.fractionLength(1)))) кг")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundStyle(CFColor.accent)
                    }
                }

                Chart(chartWeights) { entry in
                    AreaMark(
                        x: .value("Дата", entry.date),
                        yStart: .value("Минимум", chartWeights.map(\.kilograms).min() ?? entry.kilograms - 1),
                        yEnd: .value("Вес", entry.kilograms)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [CFColor.accent.opacity(0.24), CFColor.accent.opacity(0.01)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)

                    LineMark(
                        x: .value("Дата", entry.date),
                        y: .value("Вес", entry.kilograms)
                    )
                    .foregroundStyle(CFColor.accent)
                    .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .interpolationMethod(.catmullRom)

                    PointMark(
                        x: .value("Дата", entry.date),
                        y: .value("Вес", entry.kilograms)
                    )
                    .foregroundStyle(CFColor.accent)
                    .symbolSize(28)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
                        AxisGridLine().foregroundStyle(CFColor.divider.opacity(0.55))
                        AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                            .foregroundStyle(CFColor.secondary)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { value in
                        AxisGridLine().foregroundStyle(CFColor.divider.opacity(0.55))
                        AxisValueLabel()
                            .foregroundStyle(CFColor.secondary)
                    }
                }
                .frame(height: 170)
                .accessibilityLabel("График веса за выбранный период")
            }
        }
    }

    private var activityGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            metricCard(
                icon: "fork.knife",
                value: "\(Int(store.current.todayCalories))",
                label: "ккал сегодня",
                tint: CFColor.accent
            )
            metricCard(
                icon: "figure.strengthtraining.traditional",
                value: "\(store.current.completedWorkouts)",
                label: "тренировки",
                tint: CFColor.blue
            )
            metricCard(
                icon: "figure.walk",
                value: "\(store.current.steps.formatted())",
                label: "шаги",
                tint: CFColor.warning
            )
            metricCard(
                icon: "drop.fill",
                value: store.current.waterLitres.formatted(.number.precision(.fractionLength(1))),
                label: "литры",
                tint: CFColor.accent
            )
        }
    }

    private func metricCard(icon: String, value: String, label: String, tint: Color) -> some View {
        CFCard {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(tint)
                Text(value)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .monospacedDigit()
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(CFColor.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var monthReport: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Отчёт месяца")
            NavigationLink {
                ReportsView()
            } label: {
                CFCard {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            IconTile(systemName: "doc.text.fill", tint: CFColor.blue, size: 46)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Октябрь 2026")
                                    .font(.system(size: 17, weight: .semibold))
                                Text("Готов 1 ноября")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(CFColor.secondary)
                            }
                            Spacer()
                            CFPill(text: "PDF", tint: CFColor.secondary)
                        }

                        Divider().overlay(CFColor.divider)

                        HStack {
                            reportValue("+1,9 кг", "к весу")
                            reportValue("78%", "план питания")
                            reportValue("14", "тренировок")
                        }
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }

    private func reportValue(_ value: String, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(CFColor.secondary)
        }
    }

    private var achievements: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Достижения")
            HStack(spacing: 10) {
                achievement("7 дней", "серия", "flame.fill", CFColor.warning)
                achievement("4", "недели", "calendar", CFColor.blue)
                achievement("12", "рекордов", "trophy.fill", CFColor.accent)
            }
        }
    }

    private func achievement(_ value: String, _ label: String, _ icon: String, _ tint: Color) -> some View {
        VStack(spacing: 9) {
            Image(systemName: icon)
                .font(.system(size: 21, weight: .semibold))
                .foregroundStyle(tint)
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(CFColor.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(CFColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct ReportsView: View {
    private let reports = [
        ("Ноябрь 2026", "Формируется", false),
        ("Октябрь 2026", "1 ноября", true),
        ("Сентябрь 2026", "1 октября", true),
        ("Август 2026", "1 сентября", true)
    ]

    var body: some View {
        List {
            ForEach(reports, id: \.0) { report in
                HStack(spacing: 12) {
                    IconTile(systemName: "doc.text.fill", tint: report.2 ? CFColor.accent : CFColor.secondary, size: 42)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(report.0)
                            .font(.system(size: 15, weight: .semibold))
                        Text(report.1)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }
                    Spacer()
                    if report.2 {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundStyle(CFColor.accent)
                    }
                }
                .listRowBackground(CFColor.card)
            }
        }
        .scrollContentBackground(.hidden)
        .cfScreen()
        .navigationTitle("История отчётов")
        .navigationBarTitleDisplayMode(.inline)
    }
}

