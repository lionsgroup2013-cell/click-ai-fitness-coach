import SwiftUI

struct MoreView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                title
                profileCard
                coachCard
                menu
                privacyCard
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 28)
        }
        .scrollIndicators(.hidden)
        .cfScreen()
        .navigationBarTitleDisplayMode(.inline)
    }

    private var title: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("ЦЕНТР УПРАВЛЕНИЯ")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .tracking(1.2)
                .foregroundStyle(CFColor.accent)
            Text("Ещё")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text("Тренер, покупки, рецепты и настройки")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(CFColor.secondary)
        }
        .padding(.top, 8)
    }

    private var profileCard: some View {
        Menu {
            ForEach(store.profiles) { profile in
                Button {
                    store.switchProfile(to: profile.id)
                } label: {
                    Label(
                        profile.name,
                        systemImage: profile.id == store.selectedProfileID ? "checkmark" : "person"
                    )
                }
            }
        } label: {
            CFCard {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(CFColor.accent.opacity(0.15))
                        Text(String(store.current.name.prefix(1)))
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundStyle(CFColor.accent)
                    }
                    .frame(width: 62, height: 62)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(store.current.name)
                            .font(.system(size: 20, weight: .semibold))
                        Text("\(store.current.goal.title) · \(store.current.age) лет")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 5) {
                        CFPill(text: "ПРОФИЛЬ 1")
                        Text("Сменить")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(CFColor.secondary)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var coachCard: some View {
        Button {
            store.showChatSheet = true
        } label: {
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 19, style: .continuous)
                        .fill(CFColor.accent)
                    Image(systemName: "sparkles")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(CFColor.background)
                }
                .frame(width: 58, height: 58)

                VStack(alignment: .leading, spacing: 3) {
                    Text("ИИ-тренер")
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                    Text("Ответы по вашим реальным данным")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(CFColor.secondary)
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(CFColor.background)
                    .frame(width: 34, height: 34)
                    .background(CFColor.accent)
                    .clipShape(Circle())
            }
            .padding(18)
            .background(
                LinearGradient(
                    colors: [CFColor.accent.opacity(0.18), CFColor.card],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var menu: some View {
        VStack(spacing: 0) {
            NavigationLink {
                StoresView()
            } label: {
                menuRow("Магазины и покупки", subtitle: "Пятёрочка и Дикси", icon: "cart.fill")
            }
            divider
            NavigationLink {
                ProductsView()
            } label: {
                menuRow("Мои продукты", subtitle: "Сохранённые этикетки и БЖУ", icon: "barcode.viewfinder")
            }
            divider
            NavigationLink {
                RecipesView()
            } label: {
                menuRow("Мои рецепты", subtitle: "\(store.current.recipes.count) сохранённых рецепта", icon: "book.fill")
            }
            divider
            NavigationLink {
                ReportsView()
            } label: {
                menuRow("История отчётов", subtitle: "Недельные и месячные", icon: "doc.text.fill")
            }
            divider
            NavigationLink {
                ProfileSettingsView()
            } label: {
                menuRow("Профиль", subtitle: "Цель, параметры и безопасность", icon: "person.fill")
            }
            divider
            NavigationLink {
                SettingsView()
            } label: {
                menuRow("Настройки", subtitle: "Уведомления, Health, данные", icon: "gearshape.fill")
            }
        }
        .padding(.horizontal, 16)
        .background(CFColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var divider: some View {
        Divider()
            .overlay(CFColor.divider)
            .padding(.leading, 54)
    }

    private func menuRow(_ title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: 13) {
            IconTile(systemName: icon, tint: CFColor.accent, size: 40)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                Text(subtitle)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(CFColor.secondary)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(CFColor.secondary)
        }
        .foregroundStyle(CFColor.text)
        .padding(.vertical, 12)
    }

    private var privacyCard: some View {
        HStack(alignment: .top, spacing: 11) {
            Image(systemName: "lock.shield.fill")
                .foregroundStyle(CFColor.accent)
            Text("Данные профилей хранятся отдельно. API-ключи никогда не попадают в iOS-приложение.")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(CFColor.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 4)
    }
}

struct StoresView: View {
    @Environment(AppStore.self) private var store
    @State private var storeFilter = "Пятёрочка"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Picker("Магазин", selection: $storeFilter) {
                    Text("Пятёрочка").tag("Пятёрочка")
                    Text("Дикси").tag("Дикси")
                }
                .pickerStyle(.segmented)

                CFCard {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Список покупок")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(CFColor.secondary)
                            Text("\(totalPrice) ₽")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                        }
                        Spacer()
                        CFPill(text: "ОЦЕНКА", tint: CFColor.accent)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "На неделю")
                    ForEach(store.current.shopping.filter { $0.store == storeFilter }) { item in
                        Button {
                            store.toggleShopping(item.id)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 21))
                                    .foregroundStyle(item.isChecked ? CFColor.accent : CFColor.secondary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(.system(size: 15, weight: .semibold))
                                        .strikethrough(item.isChecked)
                                    Text(item.quantity)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(CFColor.secondary)
                                }
                                Spacer()
                                Text("\(item.estimatedPrice) ₽")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(CFColor.text)
                            .padding(14)
                            .background(CFColor.card)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }

                CFCard {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Цены и наличие")
                            .font(.system(size: 14, weight: .semibold))
                        Text("В этой версии показаны сохранённые оценки. Онлайн-каталоги не подключены, поэтому цены не выдаются за актуальные.")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }
                }
            }
            .padding(18)
        }
        .cfScreen()
        .navigationTitle("Магазины")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var totalPrice: Int {
        store.current.shopping.filter { $0.store == storeFilter && !$0.isChecked }.reduce(0) { $0 + $1.estimatedPrice }
    }
}

struct ProductsView: View {
    @Environment(AppStore.self) private var store

    private let products = [
        ("Творог 5%", "121 ккал · Б 18 · Ж 5 · У 3", "180 г"),
        ("Куриное филе", "165 ккал · Б 31 · Ж 3,6 · У 0", "1,2 кг"),
        ("Овсяные хлопья", "379 ккал · Б 13 · Ж 6,5 · У 62", "800 г")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Button {
                    store.showScannerSheet = true
                } label: {
                    Label("Сканировать этикетку", systemImage: "barcode.viewfinder")
                }
                .buttonStyle(PrimaryButtonStyle())

                ForEach(products, id: \.0) { product in
                    CFCard {
                        HStack(spacing: 13) {
                            IconTile(systemName: "takeoutbag.and.cup.and.straw.fill", tint: CFColor.accent, size: 44)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.0)
                                    .font(.system(size: 16, weight: .semibold))
                                Text(product.1)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(CFColor.secondary)
                            }
                            Spacer()
                            Text(product.2)
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundStyle(CFColor.accent)
                        }
                    }
                }

                CFCard {
                    Text("Продукты на 100 г. Значения можно проверить и исправить перед сохранением записи.")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(CFColor.secondary)
                }
            }
            .padding(18)
        }
        .cfScreen()
        .navigationTitle("Мои продукты")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecipesView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(store.current.recipes) { recipe in
                    CFCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                IconTile(systemName: "book.fill", tint: CFColor.accent, size: 44)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(recipe.title)
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("\(recipe.calories) ккал · \(recipe.protein) г белка")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(CFColor.secondary)
                                }
                                Spacer()
                            }
                            Divider().overlay(CFColor.divider)
                            Text(recipe.ingredients.joined(separator: " · "))
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(CFColor.secondary)
                        }
                    }
                }
            }
            .padding(18)
        }
        .cfScreen()
        .navigationTitle("Мои рецепты")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileSettingsView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        List {
            Section("Текущий профиль") {
                LabeledContent("Имя", value: store.current.name)
                LabeledContent("Возраст", value: "\(store.current.age) лет")
                LabeledContent("Рост", value: "\(store.current.height) см")
                LabeledContent("Текущий вес", value: "\(store.current.currentWeight.formatted(.number.precision(.fractionLength(1)))) кг")
                LabeledContent("Цель", value: store.current.goal.title)
            }
            .listRowBackground(CFColor.card)

            Section("Дневные цели") {
                LabeledContent("Калории", value: "\(store.current.dailyCalories)")
                LabeledContent("Белки", value: "\(store.current.dailyProtein) г")
                LabeledContent("Жиры", value: "\(store.current.dailyFat) г")
                LabeledContent("Углеводы", value: "\(store.current.dailyCarbs) г")
            }
            .listRowBackground(CFColor.card)

            Section("Профили") {
                ForEach(store.profiles) { profile in
                    Button {
                        store.switchProfile(to: profile.id)
                    } label: {
                        HStack {
                            Text(profile.name)
                            Spacer()
                            if profile.id == store.selectedProfileID {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(CFColor.accent)
                            }
                        }
                        .foregroundStyle(CFColor.text)
                    }
                }
            }
            .listRowBackground(CFColor.card)
        }
        .scrollContentBackground(.hidden)
        .cfScreen()
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView: View {
    @Environment(AppStore.self) private var store
    @State private var mealReminder = true
    @State private var workoutReminder = true
    @State private var weeklyReminder = false

    var body: some View {
        List {
            Section("Напоминания") {
                Toggle("Приёмы пищи", isOn: $mealReminder)
                Toggle("Тренировки", isOn: $workoutReminder)
                Toggle("Контрольный вес", isOn: $weeklyReminder)
            }
            .tint(CFColor.accent)
            .listRowBackground(CFColor.card)

            Section("Интеграции") {
                LabeledContent("Apple Health", value: "Не подключено")
                LabeledContent("ИИ-сервер", value: "Локальный режим")
                LabeledContent("Магазины", value: "Сохранённый список")
            }
            .listRowBackground(CFColor.card)

            Section("Данные") {
                Button("Экспортировать мои данные") {
                    store.save()
                }
                Button("Удалить профиль", role: .destructive) {}
                    .disabled(true)
            }
            .listRowBackground(CFColor.card)

            Section {
                Text("Версия 0.1.0 · Stage 1\nСервер, Vision и Aggregate подключаются отдельными этапами.")
                    .font(.system(size: 11))
                    .foregroundStyle(CFColor.secondary)
            }
            .listRowBackground(CFColor.card)
        }
        .scrollContentBackground(.hidden)
        .cfScreen()
        .navigationTitle("Настройки")
        .navigationBarTitleDisplayMode(.inline)
    }
}

