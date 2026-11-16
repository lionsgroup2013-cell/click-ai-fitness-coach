import PhotosUI
import SwiftUI
import UIKit

struct NutritionView: View {
    @Environment(AppStore.self) private var store
    @State private var selectedDay = 3

    private let days = [
        ("ПН", "17"), ("ВТ", "18"), ("СР", "19"), ("ЧТ", "20"),
        ("ПТ", "21"), ("СБ", "22"), ("ВС", "23")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                title
                dayPicker
                caloriesCard
                macros
                meals
                actions
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
            Text("РАЦИОН НА НЕДЕЛЮ")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .tracking(1.2)
                .foregroundStyle(CFColor.accent)
            Text("Питание")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text("План под вашу цель и тренировки")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(CFColor.secondary)
        }
        .padding(.top, 8)
    }

    private var dayPicker: some View {
        HStack(spacing: 7) {
            ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                Button {
                    selectedDay = index
                } label: {
                    VStack(spacing: 6) {
                        Text(day.0)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(selectedDay == index ? CFColor.background.opacity(0.7) : CFColor.secondary)
                        Text(day.1)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundStyle(selectedDay == index ? CFColor.background : CFColor.text)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(selectedDay == index ? CFColor.accent : CFColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var caloriesCard: some View {
        CFCard {
            HStack(spacing: 18) {
                CircleProgress(
                    progress: store.current.todayCalories / Double(store.current.dailyCalories),
                    value: "\(store.current.remainingCalories)",
                    caption: "осталось",
                    lineWidth: 9
                )
                .frame(width: 92, height: 92)

                VStack(alignment: .leading, spacing: 8) {
                    Text("\(Int(store.current.todayCalories)) из \(store.current.dailyCalories) ккал")
                        .font(.system(size: 16, weight: .semibold))
                    Text("План на \(days[selectedDay].0), \(days[selectedDay].1) ноября")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(CFColor.secondary)
                    CFPill(text: "ПЛАН СОБЛЮДЁН", icon: "checkmark")
                }
                Spacer(minLength: 0)
            }
        }
    }

    private var macros: some View {
        HStack(spacing: 8) {
            macroCard("\(Int(store.current.todayProtein)) г", "Белки", CFColor.accent)
            macroCard("\(Int(store.current.todayFat)) г", "Жиры", CFColor.warning)
            macroCard("\(Int(store.current.todayCarbs)) г", "Углеводы", CFColor.blue)
        }
    }

    private func macroCard(_ value: String, _ title: String, _ tint: Color) -> some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(tint)
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(CFColor.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(CFColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var meals: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Меню дня")
            ForEach(store.current.meals) { meal in
                NavigationLink {
                    MealDetailView(meal: meal)
                } label: {
                    MealRow(meal: meal)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var actions: some View {
        HStack(spacing: 10) {
            Button {
                store.showFoodSheet = true
            } label: {
                Label("Добавить еду", systemImage: "plus")
            }
            .buttonStyle(PrimaryButtonStyle())

            Button {
                store.showScannerSheet = true
            } label: {
                Image(systemName: "viewfinder")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(CFColor.accent)
                    .frame(width: 50, height: 48)
                    .background(CFColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .accessibilityLabel("Сканировать продукт")
        }
    }
}

struct MealRow: View {
    @Environment(AppStore.self) private var store
    let meal: Meal

    var body: some View {
        HStack(spacing: 13) {
            Image(meal.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 92, height: 92)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text(meal.slot.rawValue.uppercased())
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .tracking(0.8)
                        .foregroundStyle(CFColor.accent)
                    Spacer()
                    Button {
                        store.toggleMeal(meal.id)
                    } label: {
                        Image(systemName: meal.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 21, weight: .medium))
                            .foregroundStyle(meal.isCompleted ? CFColor.accent : CFColor.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(meal.isCompleted ? "Отметить непринятым" : "Отметить принятым")
                }

                Text(meal.title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text("\(meal.calories) ккал · Б \(meal.protein) · Ж \(meal.fat) · У \(meal.carbs)")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(CFColor.secondary)
            }
        }
        .padding(10)
        .background(CFColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

struct MealDetailView: View {
    @Environment(AppStore.self) private var store
    let meal: Meal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(meal.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 280)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay(alignment: .topLeading) {
                        CFPill(text: meal.slot.rawValue.uppercased(), icon: "fork.knife")
                            .padding(16)
                    }

                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(meal.title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text(meal.description)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }

                    HStack(spacing: 8) {
                        nutritionPill("\(meal.calories)", "ккал", CFColor.accent)
                        nutritionPill("\(meal.protein) г", "белки", CFColor.text)
                        nutritionPill("\(meal.fat) г", "жиры", CFColor.warning)
                        nutritionPill("\(meal.carbs) г", "углев.", CFColor.blue)
                    }

                    CFCard {
                        VStack(alignment: .leading, spacing: 13) {
                            SectionHeader(title: "Ингредиенты")
                            ForEach(meal.ingredients, id: \.self) { ingredient in
                                HStack(spacing: 10) {
                                    Circle()
                                        .fill(CFColor.accent)
                                        .frame(width: 5, height: 5)
                                    Text(ingredient)
                                        .font(.system(size: 14, weight: .medium))
                                    Spacer()
                                }
                            }
                            Divider().overlay(CFColor.divider)
                            Text("Масса готового блюда: \(meal.cookedWeight) г")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(CFColor.secondary)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "Приготовление")
                        Text(meal.recipe)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(CFColor.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if let currentMeal = store.current.meals.first(where: { $0.id == meal.id }) {
                        Button {
                            store.toggleMeal(meal.id)
                        } label: {
                            Label(
                                currentMeal.isCompleted ? "Блюдо съедено" : "Отметить съеденным",
                                systemImage: currentMeal.isCompleted ? "checkmark.circle.fill" : "circle"
                            )
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                }
                .padding(.horizontal, 18)
            }
            .padding(.bottom, 30)
        }
        .ignoresSafeArea(edges: .top)
        .cfScreen()
        .navigationBarTitleDisplayMode(.inline)
    }

    private func nutritionPill(_ value: String, _ caption: String, _ tint: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(tint)
            Text(caption)
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(CFColor.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(CFColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct AddFoodSheet: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var grams = "180"
    @State private var calories = "120"
    @State private var protein = "18"
    @State private var fat = "5"
    @State private var carbs = "3"
    @State private var slot: MealSlot = .breakfast

    private var calculatedCalories: Int {
        Int((Double(calories) ?? 0) * (Double(grams) ?? 0) / 100)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    CFCard {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Расчёт по этикетке")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Укажите данные на 100 г. Итог для порции считается автоматически.")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(CFColor.secondary)
                        }
                    }

                    field("Название продукта", text: $name, keyboard: .default, placeholder: "Творог 5%")

                    Picker("Приём пищи", selection: $slot) {
                        ForEach(MealSlot.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack(spacing: 10) {
                        field("Порция, г", text: $grams, keyboard: .decimalPad)
                        field("Ккал / 100 г", text: $calories, keyboard: .decimalPad)
                    }
                    HStack(spacing: 10) {
                        field("Белки", text: $protein, keyboard: .decimalPad)
                        field("Жиры", text: $fat, keyboard: .decimalPad)
                        field("Углеводы", text: $carbs, keyboard: .decimalPad)
                    }

                    CFCard {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Порция")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(CFColor.secondary)
                                Text("\(grams.isEmpty ? "0" : grams) г")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                            }
                            Spacer()
                            Text("\(calculatedCalories) ккал")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(CFColor.accent)
                        }
                    }

                    Button("Добавить в дневник") {
                        store.addFood(
                            name: name,
                            grams: Double(grams.replacingOccurrences(of: ",", with: ".")) ?? 0,
                            caloriesPer100: Double(calories.replacingOccurrences(of: ",", with: ".")) ?? 0,
                            proteinPer100: Double(protein.replacingOccurrences(of: ",", with: ".")) ?? 0,
                            fatPer100: Double(fat.replacingOccurrences(of: ",", with: ".")) ?? 0,
                            carbsPer100: Double(carbs.replacingOccurrences(of: ",", with: ".")) ?? 0,
                            slot: slot
                        )
                        dismiss()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || Double(grams) == nil)
                }
                .padding(20)
            }
            .cfScreen()
            .navigationTitle("Добавить еду")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") { dismiss() }
                        .foregroundStyle(CFColor.secondary)
                }
            }
        }
        .presentationDetents([.large])
    }

    private func field(
        _ title: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .decimalPad,
        placeholder: String = "0"
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(CFColor.secondary)
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .padding(14)
                .background(CFColor.card)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

struct FoodScannerSheet: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedItem: PhotosPickerItem?
    @State private var hasPhoto = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 22) {
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(CFColor.card)
                    if hasPhoto {
                        VStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 46))
                                .foregroundStyle(CFColor.accent)
                            Text("Фото этикетки выбрано")
                                .font(.system(size: 17, weight: .semibold))
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 54, weight: .light))
                                .foregroundStyle(CFColor.accent)
                            Text("Наведите камеру на этикетку")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Пока Vision-модель не подключена, фото сохраняется локально, а значения этикетки нужно подтвердить вручную.")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(CFColor.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 26)
                        }
                    }
                }
                .frame(maxHeight: .infinity)

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label(hasPhoto ? "Выбрать другое фото" : "Выбрать фото этикетки", systemImage: "photo")
                }
                .buttonStyle(SecondaryButtonStyle())
                .onChange(of: selectedItem) { _, newValue in
                    guard newValue != nil else { return }
                    hasPhoto = true
                }

                Button("Ввести БЖУ вручную") {
                    dismiss()
                    store.showFoodSheet = true
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(20)
            .cfScreen()
            .navigationTitle("Сканирование")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") { dismiss() }
                        .foregroundStyle(CFColor.secondary)
                }
            }
        }
    }
}

struct AddWeightSheet: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var weight = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 22) {
                CFCard {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Утреннее взвешивание")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Для стабильной динамики взвешивайтесь в одинаковых условиях 3–7 раз в неделю.")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(CFColor.secondary)
                    }
                }

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    TextField("82,4", text: $weight)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(CFColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    Text("кг")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(CFColor.secondary)
                }

                Button("Сохранить вес") {
                    guard
                        let value = Double(weight.replacingOccurrences(of: ",", with: ".")),
                        (35...250).contains(value)
                    else { return }
                    store.addWeight(value)
                    dismiss()
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(Double(weight.replacingOccurrences(of: ",", with: ".")) == nil)

                Spacer()
            }
            .padding(20)
            .cfScreen()
            .navigationTitle("Записать вес")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") { dismiss() }
                        .foregroundStyle(CFColor.secondary)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

