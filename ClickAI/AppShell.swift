import SwiftUI

struct ContentView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        @Bindable var store = store

        TabView(selection: $store.selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(AppTab.home.title, systemImage: AppTab.home.icon)
            }
            .tag(AppTab.home)

            NavigationStack {
                NutritionView()
            }
            .tabItem {
                Label(AppTab.nutrition.title, systemImage: AppTab.nutrition.icon)
            }
            .tag(AppTab.nutrition)

            NavigationStack {
                TrainingView()
            }
            .tabItem {
                Label(AppTab.training.title, systemImage: AppTab.training.icon)
            }
            .tag(AppTab.training)

            NavigationStack {
                ProgressViewScreen()
            }
            .tabItem {
                Label(AppTab.progress.title, systemImage: AppTab.progress.icon)
            }
            .tag(AppTab.progress)

            NavigationStack {
                MoreView()
            }
            .tabItem {
                Label(AppTab.more.title, systemImage: AppTab.more.icon)
            }
            .tag(AppTab.more)
        }
        .tint(CFColor.accent)
        .sheet(isPresented: $store.showFoodSheet) {
            AddFoodSheet()
        }
        .sheet(isPresented: $store.showWeightSheet) {
            AddWeightSheet()
        }
        .sheet(isPresented: $store.showScannerSheet) {
            FoodScannerSheet()
        }
        .sheet(isPresented: $store.showChatSheet) {
            NavigationStack {
                ChatView()
            }
        }
    }
}

struct ProfileSwitcher: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        Menu {
            ForEach(store.profiles) { profile in
                Button {
                    store.switchProfile(to: profile.id)
                } label: {
                    Label(
                        "\(profile.name) · \(profile.currentWeight.formatted(.number.precision(.fractionLength(1)))) кг",
                        systemImage: profile.id == store.selectedProfileID ? "checkmark.circle.fill" : "person.circle"
                    )
                }
            }
        } label: {
            ZStack {
                Circle()
                    .fill(CFColor.surface)
                Text(String(store.current.name.prefix(1)))
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(CFColor.accent)
            }
            .frame(width: 42, height: 42)
            .accessibilityLabel("Профиль \(store.current.name)")
        }
    }
}

struct HomeView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                heroCard
                macrosCard
                quickActions
                workoutCard
                coachCard
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 28)
        }
        .scrollIndicators(.hidden)
        .cfScreen()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("CLICK")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .tracking(2.4)
                    .foregroundStyle(CFColor.text)
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(CFColor.secondary)
                Text(store.current.name)
                    .cfDisplayTitle()
            }
            Spacer()
            ProfileSwitcher()
        }
        .padding(.top, 8)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        if hour < 6 { return "Доброй ночи" }
        if hour < 12 { return "Доброе утро" }
        if hour < 18 { return "Добрый день" }
        return "Добрый вечер"
    }

    private var heroCard: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("СЕГОДНЯ")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(1.2)
                        .foregroundStyle(CFColor.secondary)
                    Text("\(store.current.remainingCalories)")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .monospacedDigit()
                    Text("ккал осталось")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(CFColor.secondary)
                }
                Spacer()
                CircleProgress(
                    progress: store.current.todayCalories / Double(store.current.dailyCalories),
                    value: "\(Int(store.current.todayCalories))",
                    caption: "съедено"
                )
                .frame(width: 108, height: 108)
            }

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(store.current.currentWeight.formatted(.number.precision(.fractionLength(1)))) кг")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    Text("\(store.weightProgressText) · \(store.current.goal.title)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(CFColor.secondary)
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(CFColor.background)
                    .frame(width: 34, height: 34)
                    .background(CFColor.accent)
                    .clipShape(Circle())
            }
            .padding(14)
            .background(CFColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .cfCard(padding: 20)
    }

    private var macrosCard: some View {
        CFCard {
            VStack(spacing: 15) {
                SectionHeader(title: "Баланс дня")
                MacroBar(title: "Белки", value: store.current.todayProtein, target: Double(store.current.dailyProtein), color: CFColor.accent)
                MacroBar(title: "Жиры", value: store.current.todayFat, target: Double(store.current.dailyFat), color: CFColor.warning)
                MacroBar(title: "Углеводы", value: store.current.todayCarbs, target: Double(store.current.dailyCarbs), color: CFColor.blue)
            }
        }
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Быстрые действия")
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                quickAction("Добавить еду", icon: "plus", tint: CFColor.accent) {
                    store.showFoodSheet = true
                }
                quickAction("Сканировать", icon: "viewfinder", tint: CFColor.blue) {
                    store.showScannerSheet = true
                }
                quickAction("Записать вес", icon: "scalemass", tint: CFColor.warning) {
                    store.showWeightSheet = true
                }
                quickAction("ИИ-тренер", icon: "sparkles", tint: CFColor.accent) {
                    store.showChatSheet = true
                }
            }
        }
    }

    private func quickAction(_ title: String, icon: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                IconTile(systemName: icon, tint: tint, size: 36)
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .foregroundStyle(CFColor.text)
            .frame(maxWidth: .infinity, minHeight: 62, alignment: .leading)
            .padding(.horizontal, 12)
            .background(CFColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var workoutCard: some View {
        NavigationLink {
            WorkoutSessionView(program: WorkoutCatalog.plans[0])
        } label: {
            ZStack(alignment: .bottomLeading) {
                Image.cf("TrainingCover")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .overlay(
                        LinearGradient(
                            colors: [.clear, CFColor.background.opacity(0.2), CFColor.background],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                VStack(alignment: .leading, spacing: 9) {
                    HStack {
                        CFPill(text: "СЕГОДНЯ", icon: "bolt.fill")
                        Spacer()
                        CFPill(text: "42 МИН", icon: "clock.fill", tint: CFColor.text)
                    }
                    Text("Верх тела")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    Text("Сила • грудь, спина и плечи")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(CFColor.secondary)
                }
                .padding(18)
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var coachCard: some View {
        CFCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    IconTile(systemName: "sparkles", tint: CFColor.accent, size: 42)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Совет тренера")
                            .font(.system(size: 15, weight: .semibold))
                        Text("На основе вашего прогресса")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }
                    Spacer()
                    CFPill(text: "ЛОКАЛЬНО", tint: CFColor.secondary)
                }
                Text("До нормы белка осталось \(max(store.current.dailyProtein - Int(store.current.todayProtein), 0)) г. Следующий приём пищи уже покрывает большую часть дневной цели.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(CFColor.text.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
                Button {
                    store.showChatSheet = true
                } label: {
                    HStack {
                        Text("Открыть тренера")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }
}

