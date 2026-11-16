import SwiftUI

struct TrainingView: View {
    @Environment(AppStore.self) private var store
    @State private var selectedProgram: WorkoutProgram?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                title
                weekCard
                nextWorkout
                programs
                history
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
        .navigationDestination(item: $selectedProgram) { program in
            WorkoutProgramDetail(program: program)
        }
    }

    private var title: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("ПЕРСОНАЛЬНЫЙ ПЛАН")
                .cfEyebrow()
            Text("Тренировки")
                .cfDisplayTitle()
            Text("Нагрузка адаптируется под восстановление")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(CFColor.secondary)
        }
        .padding(.top, 8)
    }

    private var weekCard: some View {
        CFCard {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("ЭТА НЕДЕЛЯ")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .tracking(0.8)
                            .foregroundStyle(CFColor.secondary)
                        Text("\(store.current.completedWorkouts) из 4 тренировок")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    Spacer()
                    CFPill(text: "67%", icon: "chart.bar.fill")
                }

                HStack(spacing: 7) {
                    ForEach(0..<7, id: \.self) { index in
                        let done = [0, 2, 4, 6].contains(index) && store.current.completedWorkouts > index / 2
                        VStack(spacing: 7) {
                            Circle()
                                .fill(done ? CFColor.accent : CFColor.surface)
                                .frame(width: 26, height: 26)
                                .overlay {
                                    if done {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 10, weight: .black))
                                            .foregroundStyle(CFColor.background)
                                    }
                                }
                            Text(["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ", "ВС"][index])
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(CFColor.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    private var nextWorkout: some View {
        NavigationLink {
            WorkoutSessionView(program: WorkoutCatalog.plans[0])
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    CFPill(text: "СЛЕДУЮЩАЯ", icon: "bolt.fill")
                    Spacer()
                    Text("42 МИН")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(CFColor.secondary)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Верх тела")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    Text("Грудь · спина · плечи")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(CFColor.secondary)
                }
                HStack {
                    Label("360 ккал", systemImage: "flame.fill")
                    Spacer()
                    Label("4 упражнения", systemImage: "figure.strengthtraining.traditional")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(CFColor.text)
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [CFColor.accent.opacity(0.18), CFColor.card],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(CFColor.accent.opacity(0.28), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var programs: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Программы")
            ForEach(WorkoutCatalog.plans) { program in
                Button {
                    selectedProgram = program
                } label: {
                    HStack(spacing: 14) {
                        IconTile(
                            systemName: program.id == "home" ? "house.fill" : "figure.strengthtraining.traditional",
                            tint: program.id == "legs" ? CFColor.blue : CFColor.accent,
                            size: 48
                        )
                        VStack(alignment: .leading, spacing: 3) {
                            Text(program.title)
                                .font(.system(size: 16, weight: .semibold))
                            Text(program.subtitle)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(CFColor.secondary)
                                .lineLimit(1)
                            Text("\(program.duration) мин · \(program.level)")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundStyle(CFColor.accent)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(CFColor.secondary)
                    }
                    .padding(12)
                    .background(CFColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var history: some View {
        CFCard {
            HStack(spacing: 14) {
                IconTile(systemName: "clock.arrow.circlepath", tint: CFColor.warning, size: 46)
                VStack(alignment: .leading, spacing: 3) {
                    Text("История тренировок")
                        .font(.system(size: 15, weight: .semibold))
                    Text("\(store.current.completedWorkouts) завершены · последняя 2 дня назад")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(CFColor.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(CFColor.secondary)
            }
        }
    }
}

struct WorkoutProgramDetail: View {
    let program: WorkoutProgram

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image.cf("TrainingCover")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay(alignment: .bottomLeading) {
                        LinearGradient(colors: [.clear, CFColor.background], startPoint: .top, endPoint: .bottom)
                    }

                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(program.title)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        Text(program.subtitle)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }

                    HStack(spacing: 8) {
                        detailMetric("\(program.duration)", "минут", CFColor.accent)
                        detailMetric("\(program.calories)", "ккал", CFColor.warning)
                        detailMetric("\(program.exercises.count)", "упражнений", CFColor.blue)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "Состав тренировки")
                        ForEach(program.exercises) { exercise in
                            HStack(spacing: 12) {
                                IconTile(systemName: exercise.icon, tint: CFColor.accent, size: 42)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(exercise.name)
                                        .font(.system(size: 15, weight: .semibold))
                                    Text("\(exercise.sets) подхода × \(exercise.reps)")
                                    .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(CFColor.secondary)
                                }
                                Spacer()
                                Text("\(exercise.rest) сек")
                                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                                    .foregroundStyle(CFColor.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    NavigationLink {
                        WorkoutSessionView(program: program)
                    } label: {
                        Label("Начать тренировку", systemImage: "play.fill")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal, 18)
            }
            .padding(.bottom, 30)
        }
        .ignoresSafeArea(edges: .top)
        .cfScreen()
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailMetric(_ value: String, _ label: String, _ tint: Color) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundStyle(tint)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(CFColor.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 13)
        .background(CFColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct WorkoutSessionView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    let program: WorkoutProgram

    @State private var completedSets: [UUID: Int] = [:]
    @State private var restUntil: Date?
    @State private var showFinishAlert = false

    private var totalSets: Int {
        program.exercises.reduce(0) { $0 + $1.sets }
    }

    private var doneSets: Int {
        completedSets.values.reduce(0, +)
    }

    private var progress: Double {
        totalSets == 0 ? 0 : Double(doneSets) / Double(totalSets)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                progressHeader
                restTimer
                exercises

                Button(doneSets == totalSets ? "Завершить тренировку" : "Завершить досрочно") {
                    showFinishAlert = true
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(18)
        }
        .scrollIndicators(.hidden)
        .cfScreen()
        .navigationTitle(program.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Закрыть") { dismiss() }
                    .foregroundStyle(CFColor.secondary)
            }
        }
        .alert("Завершить тренировку?", isPresented: $showFinishAlert) {
            Button("Отмена", role: .cancel) {}
            Button("Завершить") {
                store.completeWorkout()
                dismiss()
            }
        } message: {
            Text("Будут сохранены \(doneSets) из \(totalSets) выполненных подходов.")
        }
    }

    private var progressHeader: some View {
        CFCard {
            VStack(alignment: .leading, spacing: 13) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("ПРОГРЕСС")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .tracking(0.8)
                            .foregroundStyle(CFColor.secondary)
                        Text("\(doneSets) / \(totalSets) подходов")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                    }
                    Spacer()
                    CircleProgress(progress: progress, value: "\(Int(progress * 100))%", caption: "готово", lineWidth: 7)
                        .frame(width: 72, height: 72)
                }
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule().fill(CFColor.surface)
                        Capsule().fill(CFColor.accent).frame(width: proxy.size.width * progress)
                    }
                }
                .frame(height: 7)
            }
        }
    }

    @ViewBuilder
    private var restTimer: some View {
        if let restUntil {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let left = max(Int(restUntil.timeIntervalSince(context.date)), 0)
                CFCard {
                    HStack(spacing: 14) {
                        IconTile(systemName: "timer", tint: CFColor.warning, size: 46)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Отдых")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(CFColor.secondary)
                            Text("\(left / 60):\(String(format: "%02d", left % 60))")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .monospacedDigit()
                        }
                        Spacer()
                        Button("Пропустить") {
                            self.restUntil = nil
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(CFColor.accent)
                    }
                }
            }
        }
    }

    private var exercises: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Упражнения")
            ForEach(program.exercises) { exercise in
                ExerciseSessionCard(
                    exercise: exercise,
                    completed: completedSets[exercise.id, default: 0]
                ) {
                    let current = completedSets[exercise.id, default: 0]
                    guard current < exercise.sets else { return }
                    completedSets[exercise.id] = current + 1
                    restUntil = Date().addingTimeInterval(TimeInterval(exercise.rest))
                }
            }
        }
    }
}

struct ExerciseSessionCard: View {
    let exercise: Exercise
    let completed: Int
    let onSetComplete: () -> Void

    var body: some View {
        CFCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    IconTile(systemName: exercise.icon, tint: CFColor.accent, size: 44)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(exercise.name)
                            .font(.system(size: 17, weight: .semibold))
                        Text(exercise.muscles)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }
                    Spacer()
                    CFPill(text: "\(completed)/\(exercise.sets)", tint: completed == exercise.sets ? CFColor.accent : CFColor.secondary)
                }

                HStack(spacing: 8) {
                    ForEach(0..<exercise.sets, id: \.self) { index in
                        Button {
                            if index == completed {
                                onSetComplete()
                            }
                        } label: {
                            Text("\(index + 1)")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundStyle(index < completed ? CFColor.background : CFColor.text)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(index < completed ? CFColor.accent : CFColor.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Подход \(index + 1)")
                    }
                }

                HStack {
                    Label(exercise.reps, systemImage: "repeat")
                    Spacer()
                    Label("\(exercise.rest) сек", systemImage: "timer")
                }
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(CFColor.secondary)

                NavigationLink {
                    ExerciseDetailView(exercise: exercise)
                } label: {
                    HStack {
                        Text("Техника и ошибки")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(CFColor.accent)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ExerciseDetailView: View {
    let exercise: Exercise

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [CFColor.accent.opacity(0.22), CFColor.card],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Image(systemName: exercise.icon)
                        .font(.system(size: 88, weight: .light))
                        .foregroundStyle(CFColor.accent)
                }
                .frame(height: 250)

                VStack(alignment: .leading, spacing: 18) {
                    Text(exercise.name)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                    Text(exercise.muscles)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(CFColor.secondary)

                    HStack(spacing: 8) {
                        metric("\(exercise.sets)", "подхода")
                        metric(exercise.reps, "повторения")
                        metric("\(exercise.rest) с", "отдых")
                    }

                    infoCard("Техника", exercise.instruction)
                    infoCard(
                        "Варианты",
                        "Облегчённый: уменьшите амплитуду и добавьте опору. Усложнённый: замедлите опускание и увеличьте рабочий вес."
                    )
                    infoCard(
                        "Частая ошибка",
                        "Не увеличивайте нагрузку, пока движение выполняется с потерей контроля корпуса."
                    )
                }
                .padding(.horizontal, 18)
            }
            .padding(.bottom, 30)
        }
        .cfScreen()
        .navigationBarTitleDisplayMode(.inline)
    }

    private func metric(_ value: String, _ label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(CFColor.accent)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(CFColor.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(CFColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    private func infoCard(_ title: String, _ text: String) -> some View {
        CFCard {
            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                Text(text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(CFColor.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

