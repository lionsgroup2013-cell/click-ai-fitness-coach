import SwiftUI

struct ChatView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var message = ""
    @FocusState private var composerFocused: Bool

    private let prompts = [
        "Что сегодня приготовить?",
        "Сколько белка осталось?",
        "Почему вес не растёт?",
        "Как изменить тренировку?"
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 14) {
                        localModeNotice

                        ForEach(store.current.chat) { item in
                            messageBubble(item)
                                .id(item.id)
                        }

                        medicalNotice
                    }
                    .padding(16)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: store.current.chat.count) { _, _ in
                    if let last = store.current.chat.last {
                        withAnimation(.easeOut(duration: 0.25)) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            quickPrompts
            composer
        }
        .cfScreen()
        .navigationTitle("ИИ-тренер")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Закрыть") { dismiss() }
                    .foregroundStyle(CFColor.secondary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                CFPill(text: store.current.name, icon: "person.fill", tint: CFColor.accent)
            }
        }
    }

    private var localModeNotice: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lock.shield.fill")
                .foregroundStyle(CFColor.accent)
            Text("Локальный режим. Ответы формируются по данным профиля «\(store.current.name)» без отправки на сервер. Медицинские вопросы требуют консультации специалиста.")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(CFColor.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(CFColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    private var medicalNotice: some View {
        HStack(spacing: 7) {
            Image(systemName: "cross.case.fill")
            Text("Не заменяет врача")
        }
        .font(.system(size: 11, weight: .semibold))
        .foregroundStyle(CFColor.secondary.opacity(0.75))
        .padding(.top, 4)
    }

    private func messageBubble(_ item: ChatMessage) -> some View {
        HStack(alignment: .bottom, spacing: 8) {
            if item.isUser { Spacer(minLength: 42) }

            if !item.isUser {
                ZStack {
                    Circle().fill(CFColor.accent)
                    Image(systemName: "sparkles")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(CFColor.background)
                }
                .frame(width: 30, height: 30)
            }

            Text(item.text)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(item.isUser ? CFColor.background : CFColor.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(item.isUser ? CFColor.accent : CFColor.card)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 18,
                        bottomLeadingRadius: item.isUser ? 18 : 5,
                        bottomTrailingRadius: item.isUser ? 5 : 18,
                        topTrailingRadius: 18,
                        style: .continuous
                    )
                )
                .fixedSize(horizontal: false, vertical: true)

            if !item.isUser { Spacer(minLength: 28) }
        }
    }

    private var quickPrompts: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(prompts, id: \.self) { prompt in
                    Button(prompt) {
                        store.sendCoachMessage(prompt)
                    }
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(CFColor.text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(CFColor.card)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .scrollIndicators(.hidden)
        .background(CFColor.background)
    }

    private var composer: some View {
        HStack(alignment: .bottom, spacing: 9) {
            HStack(alignment: .bottom, spacing: 8) {
                Button {
                    store.showScannerSheet = true
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(CFColor.secondary)
                        .frame(width: 36, height: 36)
                }
                .accessibilityLabel("Добавить фото")

                TextField("Спросите тренера…", text: $message, axis: .vertical)
                    .focused($composerFocused)
                    .font(.system(size: 14))
                    .lineLimit(1...4)
            }
            .padding(.leading, 8)
            .padding(.trailing, 6)
            .padding(.vertical, 4)
            .background(CFColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            Button {
                store.sendCoachMessage(message)
                message = ""
                composerFocused = false
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(CFColor.background)
                    .frame(width: 44, height: 44)
                    .background(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? CFColor.secondary : CFColor.accent)
                    .clipShape(Circle())
            }
            .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .accessibilityLabel("Отправить")
        }
        .padding(.horizontal, 14)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(CFColor.background)
    }
}

