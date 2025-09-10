import SwiftUI

/// Top level AAC screen: search, category chips, grid of word tiles, play/clear bar.
struct AACGridScreen: View {
    @EnvironmentObject private var store: DataStore

    @State private var query: String = ""
    @State private var selectedCategory: WordCategory? = nil

    // grid layout
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        VStack(spacing: 0) {
            actionBar()

            categoryChips()

            searchBar()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredWords(), id: \.id) { item in
                        WordTile(item: item) {
                            store.appendToUtterance(item)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("AAC")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews
private extension AACGridScreen {
    @ViewBuilder
    func actionBar() -> some View {
        HStack(spacing: 12) {
            // Play (green circle)
            Button(action: { store.speakUtterance() }) {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(14)
                    .background(Circle().fill(Color.green))
                    .accessibilityLabel("Play")
            }

            // Current utterance chips (scrollable, light weight)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(store.currentUtterance, id: \.id) { word in
                        HStack(spacing: 6) {
                            if let icon = word.icon {
                                Image(systemName: icon)
                            }
                            Text(word.label)
                        }
                        .font(.callout)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Capsule().fill(.ultraThinMaterial))
                        .overlay(Capsule().stroke(Color.secondary.opacity(0.2)))
                    }
                }
                .padding(.vertical, 4)
            }

            // Clear (orange circle)
            Button(action: { store.clearUtterance() }) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(14)
                    .background(Circle().fill(Color.orange))
                    .accessibilityLabel("Clear")
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
    }

    @ViewBuilder
    func searchBar() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search words…", text: $query)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            if !query.isEmpty {
                Button(action: { query = "" }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    func categoryChips() -> some View {
        // Simple list of chips across two rows if needed
        let allCats = [WordCategory.core, .needs, .foodAndDrink, .people, .places, .actions, .feelings, .custom]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(allCats, id: \.self) { cat in
                    chip(title: chipTitle(for: cat), isSelected: selectedCategory == cat) {
                        selectedCategory = cat
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    func chip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    Capsule().fill(isSelected ? Color(.systemBlue).opacity(0.15) : Color(.secondarySystemBackground))
                )
                .overlay(
                    Capsule().stroke(isSelected ? Color.blue : Color.secondary.opacity(0.25))
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Helpers
private extension AACGridScreen {
    func chipTitle(for category: WordCategory) -> String {
        switch category {
        case .core: return "Core"
        case .needs: return "Needs"
        case .foodAndDrink: return "Food & Drink"
        case .people: return "People"
        case .places: return "Places"
        case .actions: return "Actions"
        case .feelings: return "Feelings"
        case .custom: return "Custom"
        }
    }

    /// Keep it simple to help the type-checker: do filtering in small steps.
    func filteredWords() -> [WordItem] {
        var items = store.items

        if let cat = selectedCategory {
            items = items.filter { $0.category == cat }
        }

        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !q.isEmpty {
            items = items.filter { item in
                if item.label.lowercased().contains(q) { return true }
                if let tags = item.tags, tags.contains(where: { $0.lowercased().contains(q) }) { return true }
                if let syns = item.synonyms, syns.contains(where: { $0.lowercased().contains(q) }) { return true }
                return false
            }
        }
        return items
    }
}

// MARK: - Word Tile
private struct WordTile: View {
    let item: WordItem
    let tap: () -> Void

    var body: some View {
        Button(action: tap) {
            VStack(spacing: 10) {
                tileIcon()
                Text(item.label)
                    .font(.callout.weight(.semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 88)
            .padding(.vertical, 14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.secondary.opacity(0.15)))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func tileIcon() -> some View {
        if let name = item.assetName, !name.isEmpty, UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(height: 28)
        } else if let sym = item.icon, !sym.isEmpty {
            Image(systemName: sym)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.accentColor)
        } else {
            Image(systemName: "square.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.accentColor)
        }
    }
}
