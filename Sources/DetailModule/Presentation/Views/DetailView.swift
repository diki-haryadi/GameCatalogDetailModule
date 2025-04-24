//
//  DetailView.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import SwiftUI
import CoreModule

public struct DetailView: View {
    @StateObject var viewModel: DetailViewModel
    private let coordinator: DetailCoordinator
    
    public init(viewModel: DetailViewModel, coordinator: DetailCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    public var body: some View {
        ScrollView {
            if viewModel.isLoading && viewModel.itemDetail == nil {
                loadingView
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else if let detail = viewModel.itemDetail {
                contentView(for: detail)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteButton
            }
        }
        .onAppear {
            viewModel.loadItemDetail()
        }
        .refreshable {
            viewModel.refreshData()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 100)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Oops!")
                .font(.title)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
            
            Button(action: {
                viewModel.refreshData()
            }) {
                Text("Try Again")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 100)
    }
    
    private func contentView(for detail: ItemDetail) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            headerView(for: detail)
            
            Divider()
            
            authorView(for: detail.author)
            
            Divider()
            
            contentSection(for: detail)
            
            tagsView(tags: detail.tags)
            
            if !viewModel.relatedItems.isEmpty {
                Divider()
                
                relatedItemsSection
            }
        }
        .padding()
    }
    
    private func headerView(for detail: ItemDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: URL(string: detail.imageUrl)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .aspectRatio(16/9, contentMode: .fit)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 240)
                        .clipped()
                case .failure:
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .aspectRatio(16/9, contentMode: .fit)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(detail.category.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text(detail.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(detail.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
                
                HStack {
                    Image(systemName: "eye")
                        .foregroundColor(.secondary)
                    Text("\(detail.viewCount) views")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text(formatDate(detail.createdAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
        }
    }
    
    private func authorView(for author: Author) -> some View {
        HStack(spacing: 12) {
            if let avatarUrl = author.avatarUrl, !avatarUrl.isEmpty {
                AsyncImage(url: URL(string: avatarUrl)) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .foregroundColor(.gray.opacity(0.3))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Circle()
                            .foregroundColor(.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "person")
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                Circle()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Author")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(author.name)
                    .font(.headline)
                
                if let bio = author.bio, !bio.isEmpty {
                    Text(bio)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Button(action: {
                coordinator.navigateToAuthor(authorId: author.id)
            }) {
                Text("Follow")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
            }
        }
    }
    
    private func contentSection(for detail: ItemDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Content")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(detail.content)
                .font(.body)
                .lineSpacing(6)
        }
    }
    
    private func tagsView(tags: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tags")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.primary)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    private var relatedItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Related Items")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(viewModel.relatedItems) { item in
                RelatedItemRow(item: item)
                    .onTapGesture {
                        coordinator.navigateToDetail(itemId: item.id)
                    }
                    .padding(.vertical, 4)
            }
        }
    }
    
    private var favoriteButton: some View {
        Button(action: {
            viewModel.toggleFavorite()
        }) {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(viewModel.isFavorite ? .red : .primary)
                .frame(width: 44, height: 44)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        Formatters.formatDate(date)
    }
}
