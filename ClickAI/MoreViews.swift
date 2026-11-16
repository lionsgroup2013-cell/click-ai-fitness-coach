import SwiftUI

struct MoreView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                title
                profileCard
                coachCard
                shoppingOverview
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
                .cfEyebrow()
            Text("Ещё")
                .cfDisplayTitle()
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
                            .font(.system(size: 22, weight: .black, design: .rounded))
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

    private var shoppingOverview: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Покупки на неделю")

            HStack(spacing: 9) {
                NavigationLink {
                    StoresView(initialStore: "Пятёрочка")
                } label: {
                    StoreTile(
                        mark: "5",
                        title: "Пятёрочка",
                        subtitle: "Курица · лосось · овощи",
                        total: "978 ₽",
                        tint: CFColor.accent
                    )
                }
                .buttonStyle(.plain)

                NavigationLink {
                    StoresView(initialStore: "Дикси")
                } label: {
                    StoreTile(
                        mark: "Д",
                        title: "Дикси",
                        subtitle: "Рис · овощи · бюджет",
                        total: "448 ₽",
                        tint: CFColor.blue
                    )
                }
                .buttonStyle(.plain)
            }

            NavigationLink {
                ProductsView()
            } label: {
                HStack(spacing: 11) {
                    IconTile(systemName: "barcode.viewfinder", tint: CFColor.accent, size: 40)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Мои продукты · БЖУ")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                        Text("Творог 5% · курица · овсянка")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }
                    Spacer()
                    Text("3 продукта")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(CFColor.accent)
                }
                .foregroundStyle(CFColor.text)
                .padding(12)
                .background(CFColor.card)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.055), lineWidth: 1)
                }
            }
            .buttonStyle(.plain)
        }
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
                    .font(.system(size: 11, weight: .medium))
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

struct StoreTile: View {
    let mark: String
    let title: String
    let subtitle: String
    let total: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(mark)
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundStyle(CFColor.background)
                .frame(width: 36, height: 36)
                .background(tint)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .black, design: .rounded))
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(CFColor.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            Text(total)
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(tint)
        }
        .foregroundStyle(CFColor.text)
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
        .padding(13)
        .background(CFColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.055), lineWidth: 1)
        }
    }
}

struct StoresView: View {
    @Environment(AppStore.self) private var store
    @State private var storeFilter: String
    @State private var mode = 0
    @State private var category = "Все"
    @State private var search = ""

    init(initialStore: String = "Пятёрочка") {
        _storeFilter = State(initialValue: initialStore)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                storeHeader
                storePicker
                modePicker

                if mode == 0 {
                    catalog
                } else {
                    shoppingList
                }

                catalogNotice
            }
            .padding(18)
        }
        .cfScreen()
        .navigationTitle("Магазины")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var storeHeader: some View {
        CFCard {
            HStack(spacing: 14) {
                StoreTile(
                    mark: storeFilter == "Пятёрочка" ? "5" : "Д",
                    title: storeFilter,
                    subtitle: "Сохранённый каталог",
                    total: "\(totalPrice) ₽",
                    tint: storeFilter == "Пятёрочка" ? CFColor.accent : CFColor.blue
                )
                .frame(maxWidth: .infinity)

                VStack(alignment: .trailing, spacing: 5) {
                    Text("ЦЕНЫ")
                        .font(CFFont.body(10, weight: .heavy))
                        .tracking(1.2)
                        .foregroundStyle(CFColor.secondary)
                    Text("16.11")
                        .font(CFFont.display(17, weight: .bold))
                    Text("₽ за упаковку")
                        .font(CFFont.body(10, weight: .medium))
                        .foregroundStyle(CFColor.secondary)
                }
            }
        }
    }

    private var storePicker: some View {
        HStack(spacing: 8) {
            storeButton("Пятёрочка", mark: "5", tint: CFColor.accent)
            storeButton("Дикси", mark: "Д", tint: CFColor.blue)
        }
    }

    private func storeButton(_ name: String, mark: String, tint: Color) -> some View {
        Button {
            storeFilter = name
            category = "Все"
        } label: {
            HStack(spacing: 9) {
                Text(mark)
                    .font(CFFont.display(13, weight: .heavy))
                    .foregroundStyle(storeFilter == name ? CFColor.background : tint)
                    .frame(width: 30, height: 30)
                    .background(storeFilter == name ? tint : tint.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                Text(name)
                    .font(CFFont.body(14, weight: .bold))
                    .foregroundStyle(CFColor.text)

                Spacer()

                if storeFilter == name {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(tint)
                }
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
            .background(storeFilter == name ? tint.opacity(0.12) : CFColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .stroke(storeFilter == name ? tint.opacity(0.45) : Color.white.opacity(0.05), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var modePicker: some View {
        HStack(spacing: 5) {
            modeButton("Каталог", icon: "square.grid.2x2.fill", index: 0)
            modeButton("Список", icon: "checklist", index: 1)
        }
        .padding(4)
        .background(CFColor.card)
        .clipShape(Capsule())
    }

    private func modeButton(_ title: String, icon: String, index: Int) -> some View {
        Button {
            mode = index
        } label: {
            Label(title, systemImage: icon)
                .font(CFFont.body(12, weight: .bold))
                .foregroundStyle(mode == index ? CFColor.background : CFColor.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(mode == index ? CFColor.accent : Color.clear)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var catalog: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(CFColor.secondary)
                TextField("Найти продукт", text: $search)
                    .font(CFFont.body(14, weight: .medium))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(CFColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            }

            ScrollView(.horizontal) {
                HStack(spacing: 7) {
                    ForEach(categories, id: \.self) { item in
                        Button(item) {
                            category = item
                        }
                        .font(CFFont.body(11, weight: .bold))
                        .foregroundStyle(category == item ? CFColor.background : CFColor.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(category == item ? CFColor.accent : CFColor.card)
                        .clipShape(Capsule())
                    }
                }
            }
            .scrollIndicators(.hidden)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("КАТАЛОГ")
                        .font(CFFont.body(10, weight: .heavy))
                        .tracking(1.1)
                        .foregroundStyle(CFColor.accent)
                    Text("\(filteredProducts.count) товаров")
                        .font(CFFont.display(20, weight: .bold))
                }
                Spacer()
                CFPill(text: "В СПИСКЕ \(itemsForStore.count)", icon: "basket.fill")
            }

            ForEach(filteredProducts) { product in
                CatalogProductRow(product: product)
            }

            if filteredProducts.isEmpty {
                CFCard {
                    Text("Ничего не найдено. Попробуйте другой запрос или категорию.")
                        .font(CFFont.body(13, weight: .medium))
                        .foregroundStyle(CFColor.secondary)
                }
            }
        }
    }

    private var shoppingList: some View {
        VStack(alignment: .leading, spacing: 13) {
            CFCard {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("НАДО КУПИТЬ")
                            .font(CFFont.body(10, weight: .heavy))
                            .tracking(1)
                            .foregroundStyle(CFColor.secondary)
                        Text("\(totalPrice) ₽")
                            .font(CFFont.display(28, weight: .heavy))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 5) {
                        CFPill(text: "КУПЛЕНО \(checkedCount)/\(itemsForStore.count)", icon: "checkmark")
                        Text("\(remainingCount) осталось")
                            .font(CFFont.body(11, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }
                }
            }

            SectionHeader(title: "Мой список")
            Text("Нажмите на товар после покупки")
                .font(CFFont.body(11, weight: .medium))
                .foregroundStyle(CFColor.secondary)

            if itemsForStore.isEmpty {
                CFCard {
                    VStack(spacing: 9) {
                        Image(systemName: "basket")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(CFColor.accent)
                        Text("Список пока пуст")
                            .font(CFFont.display(16, weight: .bold))
                        Text("Откройте каталог и добавьте продукты")
                            .font(CFFont.body(11, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            } else {
                ForEach(itemsForStore) { item in
                    Button {
                        store.toggleShopping(item.id)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                                .font(.system(size: 23, weight: .semibold))
                                .foregroundStyle(item.isChecked ? CFColor.accent : CFColor.secondary)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.title)
                                    .font(CFFont.body(15, weight: .bold))
                                    .strikethrough(item.isChecked)
                                Text(item.isChecked ? "Куплено · \(item.quantity)" : item.quantity)
                                    .font(CFFont.body(11, weight: .medium))
                                    .foregroundStyle(item.isChecked ? CFColor.accent : CFColor.secondary)
                            }

                            Spacer()

                            Text("\(item.estimatedPrice) ₽")
                                .font(CFFont.body(13, weight: .heavy))
                        }
                        .foregroundStyle(CFColor.text)
                        .padding(14)
                        .background(item.isChecked ? CFColor.accent.opacity(0.09) : CFColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(item.isChecked ? CFColor.accent.opacity(0.28) : Color.white.opacity(0.05), lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var catalogNotice: some View {
        CFCard {
            VStack(alignment: .leading, spacing: 7) {
                Label("Сохранённый каталог", systemImage: "clock.arrow.circlepath")
                    .font(CFFont.body(13, weight: .bold))
                    .foregroundStyle(CFColor.accent)
                Text("Показаны демонстрационные фасовки и сохранённые цены на 16.11.2026. Это не живые остатки магазина. Перед покупкой проверяйте цену в приложении магазина.")
                    .font(CFFont.body(11, weight: .medium))
                    .foregroundStyle(CFColor.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var categories: [String] {
        ["Все"] + Array(Set(StoreCatalog.products.filter { $0.store == storeFilter }.map(\.category))).sorted()
    }

    private var filteredProducts: [CatalogProduct] {
        StoreCatalog.products.filter { product in
            product.store == storeFilter
                && (category == "Все" || product.category == category)
                && (search.isEmpty
                    || product.title.localizedCaseInsensitiveContains(search)
                    || product.brand.localizedCaseInsensitiveContains(search))
        }
    }

    private var itemsForStore: [ShoppingItem] {
        store.current.shopping.filter { $0.store == storeFilter }
    }

    private var checkedCount: Int {
        itemsForStore.filter(\.isChecked).count
    }

    private var remainingCount: Int {
        itemsForStore.count - checkedCount
    }

    private var totalPrice: Int {
        itemsForStore.filter { !$0.isChecked }.reduce(0) { $0 + $1.estimatedPrice }
    }
}

struct CatalogProductRow: View {
    @Environment(AppStore.self) private var store
    let product: CatalogProduct

    var body: some View {
        HStack(spacing: 12) {
            IconTile(systemName: product.icon, tint: tint, size: 48)

            VStack(alignment: .leading, spacing: 3) {
                Text(product.brand.uppercased())
                    .font(CFFont.body(9, weight: .heavy))
                    .tracking(0.8)
                    .foregroundStyle(tint)
                Text(product.title)
                    .font(CFFont.body(15, weight: .bold))
                Text("\(product.package) · \(product.calories) ккал/100 г")
                    .font(CFFont.body(10, weight: .medium))
                    .foregroundStyle(CFColor.secondary)
                Text("Б \(product.protein) · Ж \(product.fat) · У \(product.carbs)")
                    .font(CFFont.body(10, weight: .bold))
                    .foregroundStyle(CFColor.secondary)
            }

            Spacer(minLength: 4)

            VStack(alignment: .trailing, spacing: 8) {
                Text("\(product.price) ₽")
                    .font(CFFont.display(15, weight: .bold))
                Button {
                    store.addCatalogProduct(product)
                } label: {
                    Image(systemName: store.isProductInShoppingList(product) ? "checkmark" : "plus")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(CFColor.background)
                        .frame(width: 34, height: 34)
                        .background(store.isProductInShoppingList(product) ? CFColor.secondary : CFColor.accent)
                        .clipShape(Circle())
                }
                .disabled(store.isProductInShoppingList(product))
                .accessibilityLabel(store.isProductInShoppingList(product) ? "Уже в списке" : "Добавить в список")
            }
        }
        .padding(12)
        .background(CFColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 19, style: .continuous)
                .stroke(Color.white.opacity(0.055), lineWidth: 1)
        }
    }

    private var tint: Color {
        switch product.category {
        case "Белок": CFColor.accent
        case "Гарниры": CFColor.warning
        case "Овощи": Color(hex: 0x71E5A8)
        case "Молочное": Color(hex: 0xC6A7FF)
        case "Фрукты": Color(hex: 0xFFCF6B)
        default: CFColor.blue
        }
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
                                    .font(.system(size: 11, weight: .medium))
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
                Text("Версия 0.3.0 · Stage 1\nСервер, Vision и Aggregate подключаются отдельными этапами.")
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

