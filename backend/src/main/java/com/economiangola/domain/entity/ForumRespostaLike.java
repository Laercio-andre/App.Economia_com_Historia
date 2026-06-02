// src/main/java/com/economiangola/domain/entity/ForumRespostaLike.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "forum_resposta_likes", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"forum_resposta_id", "usuario_id"})
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ForumRespostaLike extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "forum_resposta_id", nullable = false)
    private ForumResposta forumResposta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;
}
