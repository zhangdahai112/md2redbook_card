<template>
  <div class="markdown-card" :style="cardStyle" :class="[getThemeClass()]">
    <div class="card-header">
      <div class="avatar">
        <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEFUlEQVR4nO2Zy08TQRzHf7ttt9vXdlugLY/ykCKgVDFchBijCXryZGLi0cR/wJvx5MXEv8G/wMR4MB4MkBiRKBBAoQVK5dlS2vJs6b7czvgkjQl0y5blIZ/kl8zOTGe+n/3NZGdmCSHBfG5yXM9lnSLHiVZJUvI8j7MoihYAwFkAOAtAKAIAglWpXQQAuKSUgLM2HphjMXaIoihkWSYAAGdmZmoZhmkUBKHK7/e/qa+vH8bUCXJAiJmZmcs+n69Pp9NZAeBDXV3dvIhAzWjmtU4ulwu0trY+K5XgIxgFCASCMJFc3UF/JK9nwJhMJgAAWDweDwCArLS0FDecQBQFpNMpIElSnDWb+wOBQL4oCrFYNgNWqzVbWlKS5ziuORqNntfr9XkA8CidTnfabLZJURRPz8zM2FdXV+Esy3bW1tb+HcU/QhTFnUBdXd24y+X6uLS0dK29vf3JyQRkWYZw+O6Tio6OiZ87gJAgCJDP50OKosDSNH1LS9PPdRACEgFMGhWXy5VOpVIrJ1XIdDrNNDU1fQqEFhWlZDZ5c3NTk8vlNjjuWHNI/X6/HIlEmng+D202m67yitNpOhJXamcHNjc3d7Y9qqpukuM4jdfrVUsS+d1YY2Pjd6fT6S0qKvpltLBbJLrzcOSP0qp4nkf+e90tlHtdHMcdUmLfOH7cAiRJQgC4O9OhUAgNDQ1FzGZzL8dxlZIkJQBAA6lU6llLSwtaWFj4bDabR0wmE/S+f4/k0W9sIpGAbre7IJEN0gAA61itVvT+Q59f7h+oVMrpDzT9pATPuACe5yHLspAk90+1Wq1iJpMBAHD+pJnvJVlqaXZjjmPrMcbEaDSiQqFAOI4DkiRBgiAQwzBgZWUlYTabn9fW1n5CCNVgjGvUarV9YWEhAI8goCiKoNfrwev1wtzcHJJlGYmiCFqtFkwmE0AISa1WyzY0NDyrqKjokCTpLsbYdOjoHIdAX18ftNls0NXVBRaLBQwGA4zPzYPH47mwPxLQaDTq+YXFrZaWlqctLS1eimK8+JgESJKEqampoR1RHAA4VwHSBYEQggRFQW1t7XZ3d/fHnp6eOq1We/G4BODhKQQBPB4PTExM+ACAA4BzEUAEQUC1WgJVVVUAAOf7+/vvVldX3/P5fAEAOBcBrNfrHdfodF6dTmcZHByc7O3t9VRWVj4EgHMRQMFg8DXG+LLP51seHR3tqqioaMUHFRg/2QB2JAGdTgcej6cbAODk5GQ4HA6/MxgMGkLo3DpxJIF4PI6i0Sgym80QDofVi4uLNkVRQJblcxOAWJZFDocDzc/PQ19fH3K5XDCwb4F/Eeb3jdx//dlfn3uSYjwexxRFbf2rDgoFhUIhZbVa/VqtdrW8vNxvNBpVe4VZ2LvQAwAJvVPpxAIY44OzvX9lVCi074nfpvgBP1esQaMl3zUAAAAASUVORK5CYII=" alt="avatar" />
      </div>
      <div class="user-info">
        <span class="username">用户名</span>
        <span class="time">刚刚</span>
      </div>
    </div>
    <div class="card-content" v-html="renderedContent"></div>
    <div class="card-footer">
      <div class="actions">
        <span class="like">❤️ 点赞</span>
        <span class="comment">💬 评论</span>
        <span class="share">🔄 分享</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue'
import MarkdownIt from 'markdown-it'
import hljs from 'highlight.js'
import 'highlight.js/styles/github.css'
import emoji from 'markdown-it-emoji'
import sub from 'markdown-it-sub'
import sup from 'markdown-it-sup'
import mark from 'markdown-it-mark'
import taskLists from 'markdown-it-task-lists'
import container from 'markdown-it-container'
import footnote from 'markdown-it-footnote'
import abbr from 'markdown-it-abbr'
import ins from 'markdown-it-ins'
import katex from 'markdown-it-katex'
import 'katex/dist/katex.min.css'

const props = defineProps({
  content: {
    type: String,
    required: true
  },
  theme: {
    type: Object,
    default: () => ({
      backgroundColor: '#ffffff',
      textColor: '#333333',
      borderColor: '#f0f0f0',
      fontFamily: 'sans-serif',
      fontSize: 16
    })
  },
  cardSize: {
    type: Object,
    default: () => ({
      width: 440,
      height: 586
    })
  }
})

const getThemeClass = () => {
  // 通过背景颜色判断主题
  if (props.theme.backgroundColor === '#fffbeb') return 'apple-memo-theme'
  if (props.theme.backgroundColor === '#f9f4ef') return 'art-deco-theme'
  if (props.theme.backgroundColor === '#ff6b6b') return 'pop-art-theme'
  if (props.theme.backgroundColor === '#f8f5e6') return 'retro-typewriter-theme'
  return ''
}

const md = new MarkdownIt({
  highlight: function (str, lang) {
    if (lang && hljs.getLanguage(lang)) {
      try {
        return hljs.highlight(str, { language: lang }).value
      } catch (__) {}
    }
    return ''
  }
})
  .use(emoji)
  .use(sub)
  .use(sup)
  .use(mark)
  .use(taskLists)
  .use(container, 'warning')
  .use(footnote)
  .use(abbr)
  .use(ins)
  .use(katex)

const renderedContent = ref('')

const cardStyle = computed(() => ({
  backgroundColor: props.theme.backgroundColor,
  color: props.theme.textColor,
  borderColor: props.theme.borderColor,
  fontFamily: props.theme.fontFamily || 'sans-serif',
  fontSize: `${props.theme.fontSize}px`,
  width: '100%',
  height: '100%'
}))

watch(() => props.content, (newContent) => {
  renderedContent.value = md.render(newContent)
}, { immediate: true })
</script>

<style scoped>
.markdown-card {
  width: 100%;
  height: 100%;
  margin: 0;
  border-radius: 0;
  box-shadow: none;
  overflow: hidden;
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
}

.card-header {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid v-bind('theme.borderColor');
  background-color: v-bind('theme.backgroundColor');
  font-family: v-bind('theme.fontFamily || "sans-serif"');
  flex-shrink: 0;
}

.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 12px;
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-info {
  display: flex;
  flex-direction: column;
}

.username {
  font-weight: bold;
  font-size: 14px;
}

.time {
  font-size: 12px;
  color: #999;
}

.card-content {
  padding: 16px;
  line-height: 1.6;
  overflow-y: auto;
  background-color: v-bind('theme.backgroundColor');
  font-family: v-bind('theme.fontFamily || "sans-serif"');
  font-size: v-bind('theme.fontSize + "px"');
  flex: 1;
  text-align: left;
}

.card-footer {
  padding: 12px 16px;
  border-top: 1px solid v-bind('theme.borderColor');
  background-color: v-bind('theme.backgroundColor');
  font-family: v-bind('theme.fontFamily || "sans-serif"');
  flex-shrink: 0;
}

.actions {
  display: flex;
  gap: 20px;
}

.actions span {
  cursor: pointer;
  font-size: 14px;
}

:deep(pre) {
  background: #f6f8fa;
  padding: 16px;
  border-radius: 6px;
  overflow-x: auto;
  font-family: 'Courier New', Courier, monospace !important;
}

:deep(code) {
  font-family: 'Courier New', Courier, monospace !important;
}

:deep(img) {
  max-width: 100%;
  border-radius: 8px;
}

:deep(p) {
  margin: 0.5em 0;
  text-align: left;
  font-size: v-bind('theme.fontSize + "px"');
}

:deep(h1), :deep(h2), :deep(h3), :deep(h4), :deep(h5), :deep(h6) {
  margin-top: 1em;
  margin-bottom: 0.5em;
  font-weight: bold;
  font-family: v-bind('theme.fontFamily || "sans-serif"');
  text-align: left;
}

:deep(h1) { font-size: v-bind('theme.fontSize * 1.8 + "px"'); }
:deep(h2) { font-size: v-bind('theme.fontSize * 1.5 + "px"'); }
:deep(h3) { font-size: v-bind('theme.fontSize * 1.3 + "px"'); }
:deep(h4) { font-size: v-bind('theme.fontSize * 1.1 + "px"'); }
:deep(h5) { font-size: v-bind('theme.fontSize + "px"'); }
:deep(h6) { font-size: v-bind('theme.fontSize + "px"'); }

:deep(ul), :deep(ol) {
  padding-left: 2em;
  margin: 0.5em 0;
  text-align: left;
  font-size: v-bind('theme.fontSize + "px"');
}

:deep(li) {
  text-align: left;
  margin-bottom: 0.3em;
  font-size: v-bind('theme.fontSize + "px"');
}

:deep(blockquote) {
  margin: 0.5em 0;
  padding-left: 1em;
  border-left: 4px solid v-bind('theme.borderColor');
  color: #666;
  text-align: left;
  font-size: v-bind('theme.fontSize + "px"');
}

:deep(.task-list-item) {
  list-style-type: none;
}

:deep(.task-list-item-checkbox) {
  margin-right: 0.5em;
}

:deep(.emoji) {
  height: 1em;
  width: 1em;
  margin: 0 0.05em 0 0.1em;
  vertical-align: -0.1em;
}

:deep(.katex-display) {
  overflow-x: auto;
  overflow-y: hidden;
  padding: 1em 0;
}

/* 苹果备忘录主题 */
.apple-memo-theme {
  border-radius: 0;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.apple-memo-theme :deep(p), 
.apple-memo-theme :deep(li) {
  line-height: 1.5;
  text-align: left;
}

.apple-memo-theme :deep(blockquote) {
  background-color: rgba(255, 224, 102, 0.2);
  border-left: 3px solid #ffe066;
  padding: 0.5em 1em;
  text-align: left;
}

/* 艺术字装饰主题 */
.art-deco-theme {
  border: 1px solid v-bind('theme.borderColor');
}

.art-deco-theme :deep(h1), 
.art-deco-theme :deep(h2) {
  text-transform: uppercase;
  letter-spacing: 2px;
  font-weight: bold;
  border-bottom: 2px solid v-bind('theme.borderColor');
  padding-bottom: 0.3em;
  text-align: left;
}

.art-deco-theme :deep(blockquote) {
  border-left: 3px solid #a48111;
  font-style: italic;
  text-align: left;
}

/* 波普艺术主题 */
.pop-art-theme {
  border-radius: 10px;
  overflow: hidden;
}

.pop-art-theme :deep(h1), 
.pop-art-theme :deep(h2),
.pop-art-theme :deep(h3) {
  text-transform: uppercase;
  letter-spacing: 1px;
  color: #1d3557;
  text-shadow: 2px 2px 0px #ffd166;
  text-align: left;
}

.pop-art-theme :deep(strong) {
  background-color: #ffd166;
  padding: 0 5px;
}

.pop-art-theme :deep(img) {
  border: 5px solid #ffd166;
}

.pop-art-theme :deep(li) {
  text-align: left;
}

/* 复古打字机主题 */
.retro-typewriter-theme {
  border: none;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAQAAAAECAYAAACp8Z5+AAAAEklEQVQImWNgYGD4z0AswK4SAFXuAf8EPy+xAAAAAElFTkSuQmCC');
}

.retro-typewriter-theme :deep(*) {
  font-family: 'Courier New', Courier, monospace !important;
}

.retro-typewriter-theme :deep(p),
.retro-typewriter-theme :deep(li) {
  letter-spacing: -0.5px;
  line-height: 1.8;
  text-align: left;
}

.retro-typewriter-theme :deep(h1),
.retro-typewriter-theme :deep(h2),
.retro-typewriter-theme :deep(h3) {
  text-decoration: underline;
  text-align: left;
}
</style> 