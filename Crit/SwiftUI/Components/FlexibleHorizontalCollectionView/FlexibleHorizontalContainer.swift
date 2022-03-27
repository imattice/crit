//
//  FlexibleHorizontalContainer.swift
//  Crit
//
//  Created by Ike Mattice on 3/24/22.
//

import SwiftUI

// MARK: - FlexibleHorizontalContainer
/// This view is responsible to lay down the given elements and wrap them into  multiple rows if needed.
/// Adopted from https://www.fivestars.blog/articles/flexible-swiftui/
extension FlexibleHorizontalCollectionView {
    struct FlexibleHorizontalContainer<Data: Collection, Content: View>: View where Data.Element: Hashable {
        let availableWidth: CGFloat
        let data: Data
        let spacing: CGFloat
        let alignment: HorizontalAlignment
        let content: (Data.Element) -> Content
        @State var elementsSize: [Data.Element: CGSize] = [:]

        var body : some View {
            VStack(alignment: alignment, spacing: spacing) {
                ForEach(computeRows(), id: \.self) { rowElements in
                    HStack(spacing: spacing) {
                        ForEach(rowElements, id: \.self) { element in
                            content(element)
                                .fixedSize()
                                .readSize { size in
                                    elementsSize[element] = size
                                }
                        }
                    }
                }
            }
        }

        func computeRows() -> [[Data.Element]] {
            var rows: [[Data.Element]] = [[]]
            var currentRow: Int = 0
            var remainingWidth: CGFloat = availableWidth

            for element in data {
                let elementSize: CGSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]

                if remainingWidth - (elementSize.width + spacing) >= 0 {
                    rows[currentRow].append(element)
                } else {
                    currentRow += 1
                    rows.append([element])
                    remainingWidth = availableWidth
                }

                remainingWidth -= (elementSize.width + spacing)
            }

            return rows
        }
    }
}