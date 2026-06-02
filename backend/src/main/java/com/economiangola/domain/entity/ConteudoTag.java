// src/main/java/com/economiangola/domain/entity/ConteudoTag.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "conteudo_tags", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"conteudo_id", "tag_id"})
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConteudoTag extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conteudo_id", nullable = false)
    private Conteudo conteudo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tag_id", nullable = false)
    private Tag tag;
}
