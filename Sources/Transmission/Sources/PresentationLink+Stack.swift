//////////////////////////////////////////////////////////////////////////////////
//
//  SYMBIOSE
//  Copyright 2023 Symbiose Technologies, Inc
//  All Rights Reserved.
//
//  NOTICE: This software is proprietary information.
//  Unauthorized use is prohibited.
//
// 
// Created by: Ryan Mckinney on 12/29/23
//
////////////////////////////////////////////////////////////////////////////////

import Foundation

#if os(iOS)

import SwiftUI
import Engine
import EngineCore
import Turbocharger

/// A modifier that presents a destination view in a new `UIViewController`.
///
/// To present the destination view with an animation, `isPresented` should
/// be updated with a transaction that has an animation. For example:
///
/// ```
/// withAnimation {
///     isPresented = true
/// }
/// ```
///
/// The destination view is presented with the provided `transition`.
/// By default, the ``PresentationLinkTransition/default`` transition is used.
///
/// See Also:
///  - ``PresentationLinkTransition``
///  - ``TransitionReader``
///
/// > Tip: You can implement custom transitions with a `UIPresentationController` and/or
/// `UIViewControllerInteractiveTransitioning` with the ``PresentationLinkTransition/custom(_:)``
///  transition.
///


@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension View {
    
    func withPresentationStack<
        T: Equatable & Identifiable, Destination: View
    >(
        _ stack: Binding<[T]>,
        transition: PresentationLinkTransition = .default,
        @ViewBuilder destination: @escaping (Binding<T>) -> Destination
    ) -> some View {
        modifier(PresentationLinkStackModifier(stack, 
                                               transition: transition, destination: destination))
    }
    
}

public class PresentationLinkStackModel<
    T: Equatable & Identifiable
>: ObservableObject {
    @Published var stack: [T]
    
    init(_ stack: [T]) {
        self.stack = stack
    }
    
}


@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PresentationLinkStackContainer<
    T: Equatable & Identifiable, Destination: View, R: View
>: View {
    
    //    let stackBinding: Binding<[T]>
    
    @ObservedObject var model: PresentationLinkStackModel<T>
    var stackBinding: Binding<[T]> { $model.stack }
    var stack: [T] { model.stack }
    var transition: PresentationLinkTransition
    
    let builder:  (Binding<T>) -> Destination
    let rootBuilder: () -> R
    
    public init(_ model: PresentationLinkStackModel<T>,
                transition: PresentationLinkTransition = .default,
                @ViewBuilder root: @escaping () -> R,
                @ViewBuilder destination: @escaping (Binding<T>) -> Destination
    ) {
        self.model = model
        self.transition = transition
        self.builder = destination
        self.rootBuilder = root
    }
    
    @ViewBuilder
    public var body: some View {
        
        ZStack {
            rootBuilder()
                .zIndex(2)
            
            ForEach(stack) { item in
                Color.clear
                    .presentation(
                        bindingForElementAfter(item),
                        transition: transition,
                        destination: builder
                    )
            }
            //            .background {
            //                ZStack {
            //                    ForEach(stack) { item in
            //
            //                        Color.clear
            //                            .presentation(bindingForElementAfter(item),
            //                                          transition: transition,
            //                                          destination: builder)
            //
            ////                        let itemBinding = bindingForElement(item)
            ////                        PresentationLinkModifierBody(
            ////                                        transition: transition,
            ////                                        isPresented: bindingForElement(item).isNotNil(),
            ////                                        destination: OptionalAdapter(bindingForElement(item), content: builder)
            ////                                    )
            //                    }
            //                }
            //            }
        }
    }
    
    
    func bindingForElementAfter(_ element: T) -> Binding<T?> {
        Binding(
            get: {
                if let index = self.stackBinding.wrappedValue.firstIndex(where: { $0.id == element.id }) {
                    //safe check
                    if index + 1 < self.stackBinding.wrappedValue.count {
                        return self.stackBinding.wrappedValue[index + 1]
                    }
                }
                return nil
            },
            set: { newVal in
                if newVal == nil {
                    if let index = self.stackBinding.wrappedValue.firstIndex(where: { $0.id == element.id }) {
                        //safe check
                        if index + 1 < self.stackBinding.wrappedValue.count {
                            self.stackBinding.wrappedValue.remove(at: index + 1)
                        }
                    }
                }
            }
        )
    }
    
    func bindingForElement(_ element: T) -> Binding<T?> {
        Binding(
            get: { self.stackBinding.wrappedValue.first(where: { $0.id == element.id }) },
            set: { newVal in
                if newVal == nil {
                    self.stackBinding.wrappedValue.removeAll { $0.id == element.id }
                }
            }
        )
    }
}




@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@frozen
public struct PresentationLinkStackModifier<
    T: Equatable & Identifiable, Destination: View
>: ViewModifier {
    
    let stackBinding: Binding<[T]>
    
    var stack: [T] { stackBinding.wrappedValue }
    var transition: PresentationLinkTransition

    let builder:  (Binding<T>) -> Destination
    
    public init(_ stack: Binding<[T]>,
                transition: PresentationLinkTransition = .default,
                @ViewBuilder destination: @escaping (Binding<T>) -> Destination
    ) {
        self.stackBinding = stack
        self.transition = transition
        self.builder = destination
    }
    
    public func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    ForEach(stack) { item in
                        
                        Color.clear
                            .presentation(bindingForElementAfter(item),
                                          transition: transition, 
                                          destination: builder)
                        
//                        let itemBinding = bindingForElement(item)
//                        PresentationLinkModifierBody(
//                                        transition: transition,
//                                        isPresented: bindingForElement(item).isNotNil(),
//                                        destination: OptionalAdapter(bindingForElement(item), content: builder)
//                                    )
                    }
                }
            }
    }
    
    func bindingForElementAfter(_ element: T) -> Binding<T?> {
        Binding(
            get: {
                if let index = self.stackBinding.wrappedValue.firstIndex(where: { $0.id == element.id }) {
                    //safe check
                    if index + 1 < self.stackBinding.wrappedValue.count {
                        return self.stackBinding.wrappedValue[index + 1]
                    }
                }
                return nil
            },
            set: { newVal in
                if newVal == nil {
                    if let index = self.stackBinding.wrappedValue.firstIndex(where: { $0.id == element.id }) {
                        //safe check
                        if index + 1 < self.stackBinding.wrappedValue.count {
                            self.stackBinding.wrappedValue.remove(at: index + 1)
                        }
                    }
                }
            }
        )
    }
    
    func bindingForElement(_ element: T) -> Binding<T?> {
        Binding(
            get: { self.stackBinding.wrappedValue.first(where: { $0.id == element.id }) },
            set: { newVal in
                if newVal == nil {
                    self.stackBinding.wrappedValue.removeAll { $0.id == element.id }
                }
            }
        )
    }
    
}

#endif
