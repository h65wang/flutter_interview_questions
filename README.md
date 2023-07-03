# Flutter Interview Questions

As Flutter is still considered a relatively new technology, it's not uncommon for job seeker to
encounter some "less professional" interview questions when applying.

So what you're seeing here, is an attempt to improve this situation.

I typically do live broadcasts on various topics on Flutter, so in the upcoming days, I will discuss
with my audience (which are some of the most experienced Flutter developers and community
contributors), and write down some what we think are higher-quality Flutter interview questions, in
the hope that this would be proven useful to Flutter learners to assess their knowledge.

Initially, we will use Markdown documents to record the questions. The plan is to develop a
question-and-answer platform using Flutter in the next a few days or weeks, which will make it
easier for everyone to use, as well as contributing more questions and answers.

These questions will be tagged based on their topics. As the question pool gradually becomes more
comprehensive, we can come up with an algorithm for the question selection mechanism, so that it can
pick questions from different tags. For example, it can pick two questions on animations, three on
syntax, another two on layouts, and so on.

This project will support multiple languages, but due to my limited abilities, I can only personally
provide content in Chinese and English. For the rest, we may need to rely on community support or
modern tools like GPT for translation.

# Flutter面试题

由于Flutter还算是一个相对新的技术，相信大家在面试Flutter岗位时，经常会遇到一些不太专业的面试题。

所以你现在看到的是一个试图改善这个窘境的新坑。

我会在直播的时候和大家一起讨论一些我们认为比较高质量的Flutter面试题并记录下来，同时也方便大家学习知识以及查漏补缺。

一开始我们会用md文档记录，过几天打算用Flutter做一个问答平台，方便大家出题和答题。

这些问题会根据话题打上相应的标签，这样当题库逐渐丰富起来之后，出题机就可以从不同标签里抽选题目。例如2题动画，3题语法，2题布局，等等。

该项目会支持多语言，但因本人能力有限，只能亲自提供中文和英文的题库，剩下的恐怕需要借助社区或GPT等现代工具完成翻译。

# Questions (draft)

The following questions came from the first session of live broadcast earlier today.

以下是首次直播时记录下来的问题草稿（都是关于动画的）。暂时还没有翻译。

## Animation

If you need to declare an AnimationController, you are likely creating:

1. a stateless widget
2. an implicit animation
3. an explicit animation
4. a AnimatedContainer widget

answer: 3

Which of the following properties of an `AnimatedContainer` will NOT get animated when its value is
changed?

1. child
2. width
3. color
4. padding

answer: 1

If you need to apply fading effect when switching texts on a screen, which of the following widget
might be useful:

1. AnimatedContainer
2. AnimatedText
3. AnimatedFade
4. AnimatedSwitcher

answer: 4

Which of the following is the default `curve` for animation widgets:

1. Curves.easeOut
2. Curves.linear
3. Curves.easeInOut
4. Curves.ease

answer: 2

Which of the following is not a parameter of `TweenAnimationBuilder` widget:

1. animation
2. duration
3. builder
4. child

answer: 1

An `AnimationController` can be used in a class with:

1. SingleTickerProviderStateMixin
2. DynamicAnimationControllerMixin
3. TickerAnimationControllerProvider
4. GetTickerBlocStateMixin

answer: 1

Which of the following best describes the purpose of a `Tween`?

1. It defines the `duration` of an animation.
2. It determines the initial state of an animation.
3. It controls animation values between `begin` and `end`.
4. It changes the `timing` of an animation loop.

answer: 3

Which of the following describes a way to apply transitions to common elements across different
screens?

1. Use `Hero` widgets and specify the same `tag`.
2. Use `Hero` widgets and specify different values for `tag`.
3. Use `Navigator` widgets and specify the same `key`.
4. Use `Navigator` widgets and specify different values for `key`.

answer: 1